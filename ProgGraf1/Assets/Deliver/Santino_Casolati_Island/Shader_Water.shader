// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Water"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_DistortionWeight("DistortionWeight", Range( 0 , 1)) = 0
		_PannerSpeed("PannerSpeed", Float) = 0
		_WaterTexture("Water Texture", 2D) = "white" {}
		_Bias("Bias", Range( 0 , 1)) = 0
		_Scale("Scale", Range( 0 , 1)) = 0
		_Pow("Pow", Range( 0 , 2)) = 0
		_NoiseSpeed("Noise Speed", Float) = 0
		_NoiseDirection("Noise Direction", Vector) = (0,0,0,0)
		_NoiseScale("Noise Scale", Float) = 0
		_NoiseHeight("Noise Height", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _NoiseSpeed;
			uniform float2 _NoiseDirection;
			uniform float _NoiseScale;
			uniform float _NoiseHeight;
			uniform sampler2D _WaterTexture;
			uniform float _PannerSpeed;
			uniform float2 _Tiling;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float _DistortionWeight;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Bias;
			uniform float _Scale;
			uniform float _Pow;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float2 appendResult153 = (float2(ase_worldPos.x , ase_worldPos.z));
				float simplePerlin2D160 = snoise( ( appendResult153 + ( ( _Time.y * _NoiseSpeed ) * _NoiseDirection ) )*_NoiseScale );
				simplePerlin2D160 = simplePerlin2D160*0.5 + 0.5;
				
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( simplePerlin2D160 * float3(0,1,0) * _NoiseHeight );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 temp_cast_0 = (_PannerSpeed).xx;
				float2 texCoord126 = i.ase_texcoord1.xy * _Tiling + float2( 0,0 );
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode122 = tex2D( _TextureSample0, uv_TextureSample0 );
				float2 appendResult123 = (float2(tex2DNode122.r , tex2DNode122.g));
				float2 lerpResult127 = lerp( texCoord126 , ( appendResult123 + texCoord126 ) , _DistortionWeight);
				float2 panner129 = ( 1.0 * _Time.y * temp_cast_0 + lerpResult127);
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth142 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth142 = abs( ( screenDepth142 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
				
				
				finalColor = saturate( ( tex2D( _WaterTexture, panner129 ) + ( 1.0 - pow( ( ( distanceDepth142 + _Bias ) * _Scale ) , _Pow ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
1523;81;732;580;-2072.779;-1375.213;2.12884;True;False
Node;AmplifyShaderEditor.CommentaryNode;151;611.6433,764.4874;Inherit;False;1868.277;651.7277;Water with flowmap;11;125;122;123;126;124;128;130;127;137;129;138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;125;661.6433,1066.609;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;0,0;100,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;122;939.7138,814.4874;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;7275a37254acf784bad856b8fb1ea0cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;150;1197.011,1453.03;Inherit;False;1288.833;413.1525;Depth Fade;8;142;144;143;146;148;145;147;149;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;165;1925.621,1895.08;Inherit;False;1228.8;713.6228;Waves;13;155;156;157;158;159;154;152;153;161;160;162;164;163;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;142;1247.011,1503.03;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;1254.863,842.9127;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;126;853.2022,1051.781;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;144;1301.944,1629.268;Inherit;False;Property;_Bias;Bias;5;0;Create;True;0;0;0;False;0;False;0;0.4870059;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;1482.266,943.0197;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;1641.112,1543.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;1507.506,1750.182;Inherit;False;Property;_Scale;Scale;6;0;Create;True;0;0;0;False;0;False;0;0.79;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;1316.714,1153.123;Inherit;False;Property;_DistortionWeight;DistortionWeight;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;1978.22,2190.863;Inherit;False;Property;_NoiseSpeed;Noise Speed;8;0;Create;True;0;0;0;False;0;False;0;60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;155;1975.621,2086.862;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;127;1624.392,1051.779;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;148;1819.806,1748.813;Inherit;False;Property;_Pow;Pow;7;0;Create;True;0;0;0;False;0;False;0;0.01;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;1856.783,1609.099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;159;2118.62,2313.067;Inherit;False;Property;_NoiseDirection;Noise Direction;9;0;Create;True;0;0;0;False;0;False;0,0;1,0.7;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;2157.621,2136.263;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;1618.447,1300.215;Inherit;False;Property;_PannerSpeed;PannerSpeed;3;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;152;2177.811,1945.081;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;129;1901.652,1243.014;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;2353.924,2246.766;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;137;1841.171,911.2717;Inherit;True;Property;_WaterTexture;Water Texture;4;0;Create;True;0;0;0;False;0;False;None;2f1167cccdf217e4e93c9d229d67fd47;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PowerNode;147;2121.147,1648.822;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;153;2392.777,1968.747;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;138;2159.921,1121.356;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;2f1167cccdf217e4e93c9d229d67fd47;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;149;2306.851,1652.602;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;2580.837,2130.456;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;161;2552.421,2276.101;Inherit;False;Property;_NoiseScale;Noise Scale;10;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;164;2780.601,2331.519;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;163;2774.52,2492.707;Inherit;False;Property;_NoiseHeight;Noise Height;11;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;160;2754.617,2212.588;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;2624.423,1330.271;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;141;2786.934,1331.9;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;2992.42,2279.101;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;167;3294.746,1567.794;Float;False;True;-1;2;ASEMaterialInspector;100;1;Shader_Water;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;123;0;122;1
WireConnection;123;1;122;2
WireConnection;126;0;125;0
WireConnection;124;0;123;0
WireConnection;124;1;126;0
WireConnection;143;0;142;0
WireConnection;143;1;144;0
WireConnection;127;0;126;0
WireConnection;127;1;124;0
WireConnection;127;2;128;0
WireConnection;145;0;143;0
WireConnection;145;1;146;0
WireConnection;157;0;155;0
WireConnection;157;1;156;0
WireConnection;129;0;127;0
WireConnection;129;2;130;0
WireConnection;158;0;157;0
WireConnection;158;1;159;0
WireConnection;147;0;145;0
WireConnection;147;1;148;0
WireConnection;153;0;152;1
WireConnection;153;1;152;3
WireConnection;138;0;137;0
WireConnection;138;1;129;0
WireConnection;149;0;147;0
WireConnection;154;0;153;0
WireConnection;154;1;158;0
WireConnection;160;0;154;0
WireConnection;160;1;161;0
WireConnection;140;0;138;0
WireConnection;140;1;149;0
WireConnection;141;0;140;0
WireConnection;162;0;160;0
WireConnection;162;1;164;0
WireConnection;162;2;163;0
WireConnection;167;0;141;0
WireConnection;167;1;162;0
ASEEND*/
//CHKSM=798F5643A1960E1CD4A4DEACF8F94B7C2CA6DEFE