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
258;73;1298;663;150.5;588.5;1;False;False
Node;AmplifyShaderEditor.Vector2Node;16;-1775.595,-350.5476;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1836.595,-471.5476;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;18;-1560.595,-377.5476;Inherit;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-1685.595,-167.5476;Inherit;False;Property;_RingRadius;RingRadius;2;0;Create;True;0;0;0;False;0;False;0.42;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1703.595,-66.54761;Inherit;False;Property;_RingThickness;RingThickness;3;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1574.595,-472.5476;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1613.595,58.45239;Inherit;False;Property;_Softness;Softness;4;0;Create;True;0;0;0;False;0;False;0.015;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1407.595,-162.5476;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1391.595,-434.5476;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1190.595,-77.54761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1407.595,-67.54761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1184.5,213.5;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1170.5,303.5;Inherit;False;Property;_PulseSpeed;PulseSpeed;6;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;11;-1231.595,-413.5476;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-1033.595,-392.5476;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;12;-1050.595,-220.5476;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-998.5,214.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;35;-851.5,213.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-867.5952,-389.5476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-887.5952,-228.5476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-690.5952,-334.5476;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-718.5,212.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-594.5952,-139.5476;Inherit;False;Property;_GlowColor;GlowColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0.03058815,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-575.5,199.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-704.5,49.5;Inherit;False;Property;_PulseMin;PulseMin;7;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-704.5,121.5;Inherit;False;Property;_PulseMax;PulseMax;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;4;-522.5952,-332.5476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-328.5,-183.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;5;-419.5952,-535.5476;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0.07075471,0.9905071,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;38;-433.5,53.5;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-144.5,-217.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-167.5,-444.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;52.5,-441.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;254.5,-438.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-579.5952,-238.5476;Inherit;False;Property;_AlphaMultiplier;AlphaMultiplier;5;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;457.5,-451.5;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-201.5,-313.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;644.5,-424.5;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;818,-424;Float;False;True;-1;2;ASEMaterialInspector;100;1;ASE_In;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;7;0;10;0
WireConnection;7;1;6;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;8;0;7;0
WireConnection;8;1;22;0
WireConnection;9;0;10;0
WireConnection;9;1;22;0
WireConnection;11;0;20;0
WireConnection;13;0;11;0
WireConnection;13;1;10;0
WireConnection;13;2;9;0
WireConnection;12;0;11;0
WireConnection;12;1;7;0
WireConnection;12;2;8;0
WireConnection;34;0;33;0
WireConnection;34;1;30;0
WireConnection;35;0;34;0
WireConnection;14;0;13;0
WireConnection;15;0;12;0
WireConnection;2;0;14;0
WireConnection;2;1;15;0
WireConnection;36;0;35;0
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
//CHKSM=20E7949EB355BDC8A6D376D411B816D46D2C39C3