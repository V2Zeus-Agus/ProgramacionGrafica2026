// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE_PlataformaSalto_Energia"
{
	Properties
	{
		_AlphaMultiplier("AlphaMultiplier", Float) = 0.8
		_ScrollSpeed("ScrollSpeed", Float) = 1
		_StripeCount("StripeCount", Float) = 4
		_StripeWidth("StripeWidth", Float) = 0.2
		_EdgeFade("EdgeFade", Float) = 0.15

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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _EdgeFade;
			uniform float _StripeWidth;
			uniform float _StripeCount;
			uniform float _ScrollSpeed;
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
				float4 color1 = IsGammaSpace() ? float4(1,0.03997353,0,0) : float4(1,0.003093926,0,0);
				float2 texCoord11 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break12 = texCoord11;
				float smoothstepResult23 = smoothstep( ( 1.0 - _EdgeFade ) , 1.0 , abs( ( ( break12.x * 2.0 ) - 1.0 ) ));
				float smoothstepResult18 = smoothstep( 0.0 , _StripeWidth , frac( ( ( ( abs( ( ( break12.x * 2.0 ) - 1.0 ) ) + abs( ( ( break12.y * 2.0 ) - 1.0 ) ) ) * _StripeCount ) - ( _Time.y * _ScrollSpeed ) ) ));
				float temp_output_27_0 = ( ( 1.0 - smoothstepResult23 ) * ( 1.0 - smoothstepResult18 ) );
				float4 break30 = ( color1 * temp_output_27_0 );
				float4 appendResult31 = (float4(break30.r , break30.g , break30.b , ( temp_output_27_0 * _AlphaMultiplier )));
				
				
				finalColor = appendResult31;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
149;73;1296;626;-1447.41;236.6111;1.35245;False;False
Node;AmplifyShaderEditor.CommentaryNode;40;-408.1267,-10;Inherit;False;416;209;Separa las UVs del plano ;2;11;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-358.1267,40;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;41;58.56786,-50.20827;Inherit;False;510.3535;420.2083;Centra y transforma las UVs para generar la forma principal;6;35;32;33;36;34;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-144.1266,45;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;118,228;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;126,121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;268,235;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;271,125;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;37;413,235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;34;414,126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;43;486.2058,438.1324;Inherit;False;418;276.9998;mover el patrón y generar sensación de energía;3;4;14;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;653.1615,120.9657;Inherit;False;520.0392;295.8971;cantidad de líneas o repeticiones del patrón;3;39;16;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;800.4586,-218.0593;Inherit;False;965.0385;321.5172;Suaviza los bordes;7;21;20;23;22;25;26;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;520.5883,151.4142;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;536.2059,527.1323;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;552.2059,599.1321;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;703.1615,274.4851;Inherit;False;Property;_StripeCount;StripeCount;2;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;850.4586,-109.4438;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;742.2059,488.1324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;812.7521,170.9657;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;1203.855,174.4486;Inherit;False;623.3795;333.2746;ancho y suavizado de las líneas animadas;4;19;17;6;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;1007.201,281.8627;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;1119.789,-0.4047852;Inherit;False;Property;_EdgeFade;EdgeFade;4;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;1026.808,-116.7551;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;1253.855,391.7232;Inherit;False;Property;_StripeWidth;StripeWidth;3;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;17;1288.855,294.7232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;1308.365,-34.30421;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;22;1192.674,-117.8237;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;1461.193,-121.0273;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;18;1471.855,283.7232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;1649.786,-35.82138;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;1648.234,224.4486;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;1899.678,-104.7917;Inherit;False;Constant;_MainColor;MainColor;1;0;Create;True;0;0;0;False;0;False;1,0.03997353,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;1959.678,105.2083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;2044.535,316.4485;Inherit;False;Property;_AlphaMultiplier;AlphaMultiplier;0;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;2141.677,75.20829;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;30;2295.676,64.20829;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;2245.568,217.1396;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;2497.676,68.20829;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2700.676,68.20829;Float;False;True;-1;2;ASEMaterialInspector;100;1;ASE_PlataformaSalto_Energia;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;12;0;11;0
WireConnection;35;0;12;1
WireConnection;32;0;12;0
WireConnection;36;0;35;0
WireConnection;33;0;32;0
WireConnection;37;0;36;0
WireConnection;34;0;33;0
WireConnection;38;0;34;0
WireConnection;38;1;37;0
WireConnection;20;0;12;0
WireConnection;15;0;14;0
WireConnection;15;1;4;0
WireConnection;39;0;38;0
WireConnection;39;1;5;0
WireConnection;16;0;39;0
WireConnection;16;1;15;0
WireConnection;21;0;20;0
WireConnection;17;0;16;0
WireConnection;26;1;25;0
WireConnection;22;0;21;0
WireConnection;23;0;22;0
WireConnection;23;1;26;0
WireConnection;18;0;17;0
WireConnection;18;2;6;0
WireConnection;24;0;23;0
WireConnection;19;0;18;0
WireConnection;27;0;24;0
WireConnection;27;1;19;0
WireConnection;28;0;1;0
WireConnection;28;1;27;0
WireConnection;30;0;28;0
WireConnection;29;0;27;0
WireConnection;29;1;3;0
WireConnection;31;0;30;0
WireConnection;31;1;30;1
WireConnection;31;2;30;2
WireConnection;31;3;29;0
WireConnection;0;0;31;0
ASEEND*/
//CHKSM=BD0CA43FC92A70447AE2B799AAE3A7A80E39275C