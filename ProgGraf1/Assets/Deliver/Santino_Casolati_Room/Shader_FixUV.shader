// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_FixUV"
{
	Properties
	{
		_TextureScale("Texture Scale", Float) = 0
		_DisplacementTexture("Displacement Texture", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_NormalTexture("Normal Texture", 2D) = "bump" {}
		_DisplacementStrength("DisplacementStrength", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _DisplacementTexture;
		uniform float _TextureScale;
		uniform float _DisplacementStrength;
		uniform sampler2D _NormalTexture;
		uniform sampler2D _MainTex;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 temp_output_3_0 = ( (ase_worldPos).xy / _TextureScale );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.normal = ( ( ( ( tex2Dlod( _DisplacementTexture, float4( temp_output_3_0, 0, 0.0) ).r - 0.5 ) * _DisplacementStrength ) * ase_worldNormal ) + ase_vertex3Pos );
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_3_0 = ( (ase_worldPos).xy / _TextureScale );
			o.Normal = ( tex2D( _NormalTexture, temp_output_3_0 ) * 1.0 ).rgb;
			o.Albedo = tex2D( _MainTex, temp_output_3_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1523;81;732;530;1111.136;108.739;3.036306;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1466.777,307.0909;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;2;-1269.482,353.3519;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1294.88,467.6017;Inherit;False;Property;_TextureScale;Texture Scale;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;3;-1070.074,359.3672;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-642.4763,683.8925;Inherit;True;Property;_DisplacementTexture;Displacement Texture;1;0;Create;True;0;0;0;False;0;False;b5a976140f3bc3d43b9f29d8fb6b566a;b5a976140f3bc3d43b9f29d8fb6b566a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;21;-317.4738,683.8925;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-60.71423,912.7761;Inherit;False;Property;_DisplacementStrength;DisplacementStrength;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;34.67471,757.1418;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-610.6403,207.1373;Inherit;True;Property;_NormalTexture;Normal Texture;3;0;Create;True;0;0;0;False;0;False;a389cb3acbfc9084ba83a1552bd6c3bd;a389cb3acbfc9084ba83a1552bd6c3bd;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldNormalVector;26;167.7153,989.3385;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;196.5821,823.6625;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-597.3011,-175.6763;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;11;-204.7846,421.4029;Inherit;False;Constant;_Normal_Strength;Normal_Strength;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-305.6581,206.4143;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;30;359.7508,1043.013;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;376.0629,898.972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;95.51423,322.6022;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-314.6056,-91.80051;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;29;542.9961,947.6229;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;793.5347,333.7558;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Shader_FixUV;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;21;0;22;0
WireConnection;21;1;3;0
WireConnection;23;0;21;1
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;10;0;9;0
WireConnection;10;1;3;0
WireConnection;28;0;24;0
WireConnection;28;1;26;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;5;0;6;0
WireConnection;5;1;3;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;0;0;5;0
WireConnection;0;1;12;0
WireConnection;0;12;29;0
ASEEND*/
//CHKSM=E2184A76E9A0269AF48E7622D0A2DB6579FB63FB