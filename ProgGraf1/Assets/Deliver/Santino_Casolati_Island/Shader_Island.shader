// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Island"
{
	Properties
	{
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_HeightScale("Height Scale", Float) = 8
		_SandTex("SandTex", 2D) = "white" {}
		_DirtTex("DirtTex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _HeightScale;
		uniform sampler2D _SandTex;
		uniform float4 _SandTex_ST;
		uniform sampler2D _DirtTex;
		uniform float4 _DirtTex_ST;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.2);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_Noise = v.texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float smoothstepResult33 = smoothstep( 0.0 , 0.3 , ( 1.0 - max( abs( ( ( abs( v.texcoord.xy.x ) * 2.0 ) - 1.0 ) ) , abs( ( ( abs( v.texcoord.xy.y ) * 2.0 ) - 1.0 ) ) ) ));
			float4 temp_output_41_0 = ( ( tex2Dlod( _Noise, float4( uv_Noise, 0, 0.0) ) * saturate( smoothstepResult33 ) ) * float4( float3(0,1,0) , 0.0 ) * _HeightScale );
			v.vertex.xyz += temp_output_41_0.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_SandTex = i.uv_texcoord * _SandTex_ST.xy + _SandTex_ST.zw;
			float2 uv_DirtTex = i.uv_texcoord * _DirtTex_ST.xy + _DirtTex_ST.zw;
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float smoothstepResult33 = smoothstep( 0.0 , 0.3 , ( 1.0 - max( abs( ( ( abs( i.uv_texcoord.x ) * 2.0 ) - 1.0 ) ) , abs( ( ( abs( i.uv_texcoord.y ) * 2.0 ) - 1.0 ) ) ) ));
			float4 temp_output_41_0 = ( ( tex2D( _Noise, uv_Noise ) * saturate( smoothstepResult33 ) ) * float4( float3(0,1,0) , 0.0 ) * _HeightScale );
			float smoothstepResult45 = smoothstep( 0.2 , 0.7 , temp_output_41_0.rgb.y);
			float4 lerpResult38 = lerp( tex2D( _SandTex, uv_SandTex ) , tex2D( _DirtTex, uv_DirtTex ) , smoothstepResult45);
			o.Albedo = lerpResult38.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1523;81;732;582;2482.676;624.3403;1.775216;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-2389.895,101.6486;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;25;-2091.657,190.4256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;21;-2101.46,61.16182;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1948.657,191.4256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1958.46,62.16182;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1798.657,192.4256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-1808.46,63.16182;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;28;-1652.657,192.4256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;24;-1662.46,63.16182;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;29;-1496.332,128.0628;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-1350.333,128.0628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-1177.79,129.108;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;51;-1791.914,-189.308;Inherit;True;Property;_Noise;Noise;3;0;Create;True;0;0;0;False;0;False;None;16d574e53541bba44a84052fa38778df;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;34;-1011.79,129.108;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1558.231,-188.7894;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-828.2523,-13.47106;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;47;-854.8886,167.3363;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;42;-859.1174,325.2921;Inherit;False;Property;_HeightScale;Height Scale;0;0;Create;True;0;0;0;False;0;False;8;2.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-635.23,82.20032;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;48;-503.25,-94.01987;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1288.91,-542.0386;Inherit;True;Property;_DirtTex;DirtTex;2;0;Create;True;0;0;0;False;0;False;None;ceb1bacd3e5dc9b4cb4b85eb1a74cfb6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1290.923,-765.4738;Inherit;True;Property;_SandTex;SandTex;1;0;Create;True;0;0;0;False;0;False;None;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SmoothstepOpNode;45;-781.5845,-300.2816;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-1055.227,-541.52;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1057.24,-764.9552;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;38;-664.0174,-612.1945;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;53;-410.3378,142.7805;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-178.5822,-345.8187;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Shader_Island;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;20;2
WireConnection;21;0;20;1
WireConnection;26;0;25;0
WireConnection;22;0;21;0
WireConnection;27;0;26;0
WireConnection;23;0;22;0
WireConnection;28;0;27;0
WireConnection;24;0;23;0
WireConnection;29;0;24;0
WireConnection;29;1;28;0
WireConnection;30;0;29;0
WireConnection;33;0;30;0
WireConnection;34;0;33;0
WireConnection;52;0;51;0
WireConnection;40;0;52;0
WireConnection;40;1;34;0
WireConnection;41;0;40;0
WireConnection;41;1;47;0
WireConnection;41;2;42;0
WireConnection;48;0;41;0
WireConnection;45;0;48;1
WireConnection;19;0;18;0
WireConnection;17;0;16;0
WireConnection;38;0;17;0
WireConnection;38;1;19;0
WireConnection;38;2;45;0
WireConnection;0;0;38;0
WireConnection;0;11;41;0
WireConnection;0;14;53;0
ASEEND*/
//CHKSM=1B5D98842A42C986A842AA4DC145AC0179CBD508