// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE_Luz"
{
	Properties
	{
		_AlphaMultiplier("AlphaMultiplier", Float) = 0.22
		_LightColor("LightColor", Color) = (0.07058824,0.9921569,1,0)
		_SideFadeStart("SideFadeStart", Float) = 0.2
		_SideSoftness("SideSoftness", Float) = 0.55
		_HeightPower("HeightPower", Float) = 1.5

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
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
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

			uniform float4 _LightColor;
			uniform float _HeightPower;
			uniform float _SideFadeStart;
			uniform float _SideSoftness;
			uniform float _AlphaMultiplier;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.zw = 0;
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
				float4 break22 = _LightColor;
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float2 texCoord10 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break11 = texCoord10;
				float smoothstepResult18 = smoothstep( _SideFadeStart , ( _SideFadeStart + _SideSoftness ) , abs( ( ( break11.x * 2.0 ) - 1.0 ) ));
				float4 appendResult23 = (float4(break22.r , break22.g , break22.b , ( ( 1.0 - abs( ase_worldNormal.y ) ) * ( ( pow( ( 1.0 - break11.y ) , _HeightPower ) * ( 1.0 - smoothstepResult18 ) ) * _AlphaMultiplier ) )));
				
				
				finalColor = appendResult23;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
149;73;1296;626;-1514.624;405.051;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;28;-231,62.5;Inherit;False;748.8797;267;degradado vertical de la columna de luz;5;10;11;12;13;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-181,112.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;29;531,-65.5;Inherit;False;815;421;Suaviza los bordes laterales de la luz;8;17;4;5;19;18;15;16;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;11;24,112.5;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;582,-15.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;715,2.5;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;567,188.5;Inherit;False;Property;_SideFadeStart;SideFadeStart;2;0;Create;True;0;0;0;False;0;False;0.2;2.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;585,263.5;Inherit;False;Property;_SideSoftness;SideSoftness;3;0;Create;True;0;0;0;False;0;False;0.55;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;755.8949,244.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;16;855,4.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;18;972.8949,130.65;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;163,213.5;Inherit;False;Property;_HeightPower;HeightPower;4;0;Create;True;0;0;0;False;0;False;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;1808.824,16.04952;Inherit;False;562.1399;358.5501;visibilidad según la orientación ;4;27;26;24;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;12;178,136.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;24;1858.824,191.5996;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;30;1348.37,-42.85501;Inherit;False;446.075;263.9599;transparencia e intensidad de luz;3;3;21;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;19;1155,93.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;340.8797,119.455;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;1398.37,105.1049;Inherit;False;Property;_AlphaMultiplier;AlphaMultiplier;0;0;Create;True;0;0;0;False;0;False;0.22;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;1419.744,7.144991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;26;2033.524,231.2843;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;1901.101,-190.9351;Inherit;False;Property;_LightColor;LightColor;1;0;Create;True;0;0;0;False;0;False;0.07058824,0.9921569,1,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;1632.445,44.34498;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;2027.309,167.5793;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;2208.964,66.04952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;22;2147.19,-181.1401;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;23;2354.469,-136.705;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2492.479,-137.685;Float;False;True;-1;2;ASEMaterialInspector;100;1;ASE_Luz;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;11;0;10;0
WireConnection;14;0;11;0
WireConnection;15;0;14;0
WireConnection;17;0;4;0
WireConnection;17;1;5;0
WireConnection;16;0;15;0
WireConnection;18;0;16;0
WireConnection;18;1;4;0
WireConnection;18;2;17;0
WireConnection;12;0;11;1
WireConnection;19;0;18;0
WireConnection;13;0;12;0
WireConnection;13;1;6;0
WireConnection;20;0;13;0
WireConnection;20;1;19;0
WireConnection;26;0;24;2
WireConnection;21;0;20;0
WireConnection;21;1;3;0
WireConnection;27;0;26;0
WireConnection;25;0;27;0
WireConnection;25;1;21;0
WireConnection;22;0;2;0
WireConnection;23;0;22;0
WireConnection;23;1;22;1
WireConnection;23;2;22;2
WireConnection;23;3;25;0
WireConnection;0;0;23;0
ASEEND*/
//CHKSM=4D0526B4F171147BBC5AE279678513B59B07BF57