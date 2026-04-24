// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE_In"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0.07075471,0.9905071,1,0)
		[HDR]_GlowColor("GlowColor", Color) = (0,0.03058815,1,0)
		_RingRadius("RingRadius", Float) = 0.42
		_RingThickness("RingThickness", Float) = 0.08
		_Softness("Softness", Float) = 0.015
		_AlphaMultiplier("AlphaMultiplier", Float) = 0.7
		_PulseSpeed("PulseSpeed", Float) = 2
		_PulseMin("PulseMin", Float) = 0.2
		_PulseMax("PulseMax", Float) = 2

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _BaseColor;
			uniform float _RingRadius;
			uniform float _Softness;
			uniform float _RingThickness;
			uniform float4 _GlowColor;
			uniform float _PulseMin;
			uniform float _PulseMax;
			uniform float _PulseSpeed;
			uniform float _AlphaMultiplier;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
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
				float2 texCoord17 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_11_0 = length( ( ( texCoord17 * float2( 2,2 ) ) - float2( 1,1 ) ) );
				float smoothstepResult13 = smoothstep( _RingRadius , ( _RingRadius + _Softness ) , temp_output_11_0);
				float temp_output_7_0 = ( _RingRadius - _RingThickness );
				float smoothstepResult12 = smoothstep( temp_output_7_0 , ( temp_output_7_0 + _Softness ) , temp_output_11_0);
				float temp_output_4_0 = saturate( ( ( 1.0 - smoothstepResult13 ) - ( 1.0 - smoothstepResult12 ) ) );
				float lerpResult38 = lerp( _PulseMin , _PulseMax , ( ( sin( ( _Time.y * _PulseSpeed ) ) * 0.5 ) + 0.5 ));
				float4 break26 = ( ( ( _BaseColor * temp_output_4_0 ) + ( ( _GlowColor * temp_output_4_0 ) * lerpResult38 ) ) * lerpResult38 );
				float4 appendResult28 = (float4(break26.r , break26.g , break26.b , ( temp_output_4_0 * _AlphaMultiplier )));
				
				
				finalColor = appendResult28;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
149;73;1296;626;825.9614;366.9793;1.295;False;False
Node;AmplifyShaderEditor.CommentaryNode;44;-2093.47,-779.2775;Inherit;False;811;336;Centra las UVs y calcula distancia al centro para formar círculos;6;17;19;20;11;16;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1653.494,-442.5476;Inherit;False;1295.899;614.4;Define radio, grosor y suavidad del aro.;12;13;14;4;10;6;7;9;8;12;15;2;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2043.47,-728.2776;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;16;-1982.47,-607.2776;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;18;-1767.47,-634.2776;Inherit;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;6;-1603.494,-69.14761;Inherit;False;Property;_RingThickness;RingThickness;3;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1781.47,-729.2776;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1585.494,-170.1476;Inherit;False;Property;_RingRadius;RingRadius;2;0;Create;True;0;0;0;False;0;False;0.42;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1316.594,-172.9476;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-978.2948,191.6198;Inherit;False;983;420.0002;Anima el brillo del marcador usando Time y Sin.;9;33;30;34;35;36;37;31;32;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1598.47,-691.2776;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1513.494,55.85239;Inherit;False;Property;_Softness;Softness;4;0;Create;True;0;0;0;False;0;False;0.015;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-914.2949,495.6203;Inherit;False;Property;_PulseSpeed;PulseSpeed;6;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-928.2948,405.6203;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1316.594,-77.94763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1133.395,-80.14761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;11;-1438.47,-670.2776;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;12;-997.2948,-220.5476;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-1033.595,-392.5476;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-742.2949,406.6203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;35;-595.2949,405.6203;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-834.2951,-228.5476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-867.5952,-389.5476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-462.2953,404.6203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-659.3954,-331.9476;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-448.2953,313.6201;Inherit;False;Property;_PulseMax;PulseMax;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-448.2953,241.6198;Inherit;False;Property;_PulseMin;PulseMin;7;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-319.2953,391.6203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;4;-522.5952,-332.5476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-340.1207,-108.1475;Inherit;False;Property;_GlowColor;GlowColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0.03058815,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-255.1298,-527.7776;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0.07075471,0.9905071,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-118.5704,-130.1049;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;38;-177.295,245.6198;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;65.42999,-164.1049;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-5.625073,-428.9598;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;210.675,-425.92;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;363.2802,-448.8601;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-217.6356,-213.6225;Inherit;False;Property;_AlphaMultiplier;AlphaMultiplier;5;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;508.0052,-454.09;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;8.430037,-260.105;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;644.5,-424.5;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;818,-424;Float;False;True;-1;2;ASEMaterialInspector;100;1;ASE_In;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;7;0;10;0
WireConnection;7;1;6;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;9;0;10;0
WireConnection;9;1;22;0
WireConnection;8;0;7;0
WireConnection;8;1;22;0
WireConnection;11;0;20;0
WireConnection;12;0;11;0
WireConnection;12;1;7;0
WireConnection;12;2;8;0
WireConnection;13;0;11;0
WireConnection;13;1;10;0
WireConnection;13;2;9;0
WireConnection;34;0;33;0
WireConnection;34;1;30;0
WireConnection;35;0;34;0
WireConnection;15;0;12;0
WireConnection;14;0;13;0
WireConnection;36;0;35;0
WireConnection;2;0;14;0
WireConnection;2;1;15;0
WireConnection;37;0;36;0
WireConnection;4;0;2;0
WireConnection;40;0;21;0
WireConnection;40;1;4;0
WireConnection;38;0;31;0
WireConnection;38;1;32;0
WireConnection;38;2;37;0
WireConnection;41;0;40;0
WireConnection;41;1;38;0
WireConnection;23;0;5;0
WireConnection;23;1;4;0
WireConnection;42;0;23;0
WireConnection;42;1;41;0
WireConnection;43;0;42;0
WireConnection;43;1;38;0
WireConnection;26;0;43;0
WireConnection;24;0;4;0
WireConnection;24;1;3;0
WireConnection;28;0;26;0
WireConnection;28;1;26;1
WireConnection;28;2;26;2
WireConnection;28;3;24;0
WireConnection;0;0;28;0
ASEEND*/
//CHKSM=FD1956ACB77287FB707CE565E9E45C427DED0EE8