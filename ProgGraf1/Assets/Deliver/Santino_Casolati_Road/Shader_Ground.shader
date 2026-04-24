// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_Ground"
{
	Properties
	{
		_SandHeigth("SandHeigth", Float) = 5
		_BricksHeight("BricksHeight", Float) = 2
		_BrickTex("BrickTex", 2D) = "white" {}
		_BrickHeight("BrickHeight", 2D) = "white" {}
		_SandTex("SandTex", 2D) = "white" {}
		_SandHeight("SandHeight", 2D) = "white" {}
		_ClampHeight("ClampHeight", Float) = 1
		_Scale("Scale", Float) = 20
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BrickHeight;
		uniform float _Scale;
		uniform float _BricksHeight;
		uniform sampler2D _SandHeight;
		uniform float _SandHeigth;
		uniform float _ClampHeight;
		uniform sampler2D _BrickTex;
		uniform sampler2D _SandTex;


		float2 voronoihash64( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi64( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash64( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.2);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_Scale).xx;
			float2 uv_TexCoord82 = v.texcoord.xy * temp_cast_0;
			float4 tex2DNode61 = tex2Dlod( _BrickHeight, float4( uv_TexCoord82, 0, 0.0) );
			float time64 = 0.0;
			float2 coords64 = uv_TexCoord82 * 1.0;
			float2 id64 = 0;
			float2 uv64 = 0;
			float voroi64 = voronoi64( coords64, time64, id64, uv64, 0 );
			float4 lerpResult72 = lerp( ( tex2DNode61 * float4( float3(0,1,0) , 0.0 ) * _BricksHeight ) , ( tex2Dlod( _SandHeight, float4( uv_TexCoord82, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _SandHeigth ) , voroi64);
			float4 break73 = lerpResult72;
			float clampResult74 = clamp( break73.g , 0.0 , _ClampHeight );
			float4 appendResult76 = (float4(break73.r , clampResult74 , break73.b , 0.0));
			v.vertex.xyz += appendResult76.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Scale).xx;
			float2 uv_TexCoord82 = i.uv_texcoord * temp_cast_0;
			float time64 = 0.0;
			float2 coords64 = uv_TexCoord82 * 1.0;
			float2 id64 = 0;
			float2 uv64 = 0;
			float voroi64 = voronoi64( coords64, time64, id64, uv64, 0 );
			float smoothstepResult63 = smoothstep( 0.0 , 1.0 , voroi64);
			float4 lerpResult62 = lerp( tex2D( _BrickTex, uv_TexCoord82 ) , tex2D( _SandTex, uv_TexCoord82 ) , smoothstepResult63);
			o.Albedo = lerpResult62.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1523;81;732;530;-17.60741;1224.229;1;False;False
Node;AmplifyShaderEditor.RangedFloatNode;81;-799.3225,-955.3824;Inherit;False;Property;_Scale;Scale;7;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;59;-525.7306,-573.4873;Inherit;True;Property;_SandHeight;SandHeight;5;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;82;-587.0635,-1009.836;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;60;-527.6188,-43.88835;Inherit;True;Property;_BrickHeight;BrickHeight;3;0;Create;True;0;0;0;False;0;False;231dd91f52e60414aaaaa3dca6e0eb00;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;70;-148.8703,182.5295;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;61;-275.2469,-42.43534;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-276.3217,-570.2639;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;-136.3352,-227.1449;Inherit;False;Property;_SandHeigth;SandHeigth;0;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-154.8479,329.8696;Inherit;False;Property;_BricksHeight;BricksHeight;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;67;-138.307,-376.5711;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;90.85129,76.70882;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;101.4146,-482.3918;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;64;36.08308,-853.0818;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LerpOp;72;387.3766,-210.7075;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;41;-90.83729,-1163.699;Inherit;True;Property;_BrickTex;BrickTex;2;0;Create;True;0;0;0;False;0;False;691a8d46920a79542ad4e36c394b547a;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.BreakToComponentsNode;73;621.9804,-208.7427;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexturePropertyNode;42;-90.95828,-1374.856;Inherit;True;Property;_SandTex;SandTex;4;0;Create;True;0;0;0;False;0;False;662d72b6ec210cf4cbeec2b4d3cb8b2a;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;75;576.291,48.68107;Inherit;False;Property;_ClampHeight;ClampHeight;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;74;813.6549,-90.6171;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;161.5352,-1162.247;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;158.4501,-1371.633;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;63;343.2771,-848.1819;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;994.1847,-206.5149;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;77;1394.525,-215.2177;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;62;549.5643,-1212.385;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1646.903,-694.3312;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Shader_Ground;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;82;0;81;0
WireConnection;61;0;60;0
WireConnection;61;1;82;0
WireConnection;58;0;59;0
WireConnection;58;1;82;0
WireConnection;69;0;61;0
WireConnection;69;1;70;0
WireConnection;69;2;71;0
WireConnection;65;0;58;0
WireConnection;65;1;67;0
WireConnection;65;2;68;0
WireConnection;64;0;82;0
WireConnection;72;0;69;0
WireConnection;72;1;65;0
WireConnection;72;2;64;0
WireConnection;73;0;72;0
WireConnection;74;0;73;1
WireConnection;74;2;75;0
WireConnection;43;0;41;0
WireConnection;43;1;82;0
WireConnection;44;0;42;0
WireConnection;44;1;82;0
WireConnection;63;0;64;0
WireConnection;76;0;73;0
WireConnection;76;1;74;0
WireConnection;76;2;73;2
WireConnection;62;0;43;0
WireConnection;62;1;44;0
WireConnection;62;2;63;0
WireConnection;0;0;62;0
WireConnection;0;11;76;0
WireConnection;0;14;77;0
ASEEND*/
//CHKSM=302A82E7291C1F452CEFF9172D07DDF89DD35CFF