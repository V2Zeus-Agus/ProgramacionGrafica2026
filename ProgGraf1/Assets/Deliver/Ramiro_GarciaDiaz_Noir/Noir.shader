// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Noir"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_TargetColor("TargetColor", Color) = (1,0,0,0)
		_Tolerance("Tolerance", Float) = 0.3
		_Softness("Softness", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _Tolerance;
		uniform float _Softness;
		uniform float4 _TargetColor;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 color3 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_output_8_0 = ( tex2D( _Texture, uv_Texture ) * color3 );
			float dotResult16 = dot( temp_output_8_0 , float4( float3(0.299,0.587,0.144) , 0.0 ) );
			float3 appendResult15 = (float3(dotResult16 , dotResult16 , dotResult16));
			float smoothstepResult18 = smoothstep( _Tolerance , ( _Tolerance + _Softness ) , distance( (temp_output_8_0).rgb , (_TargetColor).rgb ));
			float4 lerpResult21 = lerp( float4( appendResult15 , 0.0 ) , saturate( ( temp_output_8_0 * 1.2 ) ) , ( 1.0 - smoothstepResult18 ));
			o.Albedo = lerpResult21.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
285;73;1922;931;830.9973;585.8382;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;1;-974.4489,-228.3123;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;2;-701.4489,-221.3123;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-966.8618,79.69984;Inherit;False;Constant;_BaseColor;BaseColor;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-298.1201,-112.2899;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;-669.9868,-509.9229;Inherit;False;Property;_TargetColor;TargetColor;1;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;27;-12.11522,-205.5471;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;26;-383.8963,-389.8387;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;215.3156,414.3391;Inherit;False;Property;_Softness;Softness;3;0;Create;True;0;0;0;False;0;False;0.2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;220.0158,198.8895;Inherit;False;Property;_Tolerance;Tolerance;2;0;Create;True;0;0;0;False;0;False;0.3;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-307.9635,68.17579;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.299,0.587,0.144;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;19;454.4273,362.3623;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-153.6369,-496.3764;Inherit;False;Constant;_ColorBoost;ColorBoost;1;0;Create;True;0;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;17;314.2898,-279.5633;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;18;468.319,70.06922;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;103.2839,-520.7762;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;16;-92.13773,-65.96798;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;23;277.6804,-520.7749;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;100.713,-96.30372;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;20;667.3205,70.54993;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;11;-1587.785,-109.0507;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;9;-1880.583,-213.0507;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;10;-1870.983,25.34934;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;21;755.2819,-146.3765;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1417.957,-112.2085;Inherit;False;Dot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1222.399,-329.7336;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Noir;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;8;0;2;0
WireConnection;8;1;3;0
WireConnection;27;0;8;0
WireConnection;26;0;4;0
WireConnection;19;0;5;0
WireConnection;19;1;6;0
WireConnection;17;0;27;0
WireConnection;17;1;26;0
WireConnection;18;0;17;0
WireConnection;18;1;5;0
WireConnection;18;2;19;0
WireConnection;22;0;8;0
WireConnection;22;1;7;0
WireConnection;16;0;8;0
WireConnection;16;1;14;0
WireConnection;23;0;22;0
WireConnection;15;0;16;0
WireConnection;15;1;16;0
WireConnection;15;2;16;0
WireConnection;20;0;18;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;21;0;15;0
WireConnection;21;1;23;0
WireConnection;21;2;20;0
WireConnection;12;0;11;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=98A20E99F034606B8653B3501BD16EBB787C735F