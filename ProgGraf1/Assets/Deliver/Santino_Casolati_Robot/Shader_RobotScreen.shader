// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader_RobotScreen"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_GlitchSpeed("Glitch Speed", Float) = 1
		_GlitchIntensity("Glitch Intensity", Float) = 1
		_HoloColor("Holo Color", Color) = (0,0,0,0)
		_GlowColor("Glow Color", Color) = (0,0,0,0)
		_FresnelPower("Fresnel Power", Range( 0.1 , 8)) = 2
		_ScanlineDensity("Scanline Density", Float) = 20
		_ScanlineSpeed("Scanline Speed", Float) = 1
		_HoloBrightness("Holo Brightness", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _HoloColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _HoloBrightness;
		uniform float _GlitchSpeed;
		uniform float _GlitchIntensity;
		uniform float4 _GlowColor;
		uniform float _FresnelPower;
		uniform float _ScanlineDensity;
		uniform float _ScanlineSpeed;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 temp_cast_0 = (( ( _Time.y * _GlitchSpeed ) * _GlitchIntensity )).xx;
			float simplePerlin2D13 = snoise( temp_cast_0 );
			simplePerlin2D13 = simplePerlin2D13*0.5 + 0.5;
			float2 appendResult21 = (float2(( uv_MainTex.x + simplePerlin2D13 ) , ( uv_MainTex.y + simplePerlin2D13 )));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV24 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode24 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV24, _FresnelPower ) );
			o.Emission = ( ( ( ( _HoloColor * tex2D( _MainTex, uv_MainTex ) ) * _HoloBrightness ) * float4( appendResult21, 0.0 , 0.0 ) ) + ( _GlowColor * fresnelNode24 ) ).rgb;
			o.Alpha = ( fresnelNode24 * step( frac( ( ( ase_worldPos.y * _ScanlineDensity ) + ( _Time.y * _ScanlineSpeed ) ) ) , 0.5 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1523;81;732;530;4049.782;1235.034;5.127108;True;False
Node;AmplifyShaderEditor.CommentaryNode;34;-2452.585,-48.33729;Inherit;False;861.6029;460.7625;Glitch Effect;6;1;2;3;4;8;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2394.585,221.4252;Inherit;False;Property;_GlitchSpeed;Glitch Speed;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-2402.585,132.4252;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1646.619,547.6047;Inherit;False;852.1881;547.7071;Scanline;9;6;10;7;5;14;12;19;22;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2249.585,296.4252;Inherit;False;Property;_GlitchIntensity;Glitch Intensity;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-2207.585,158.4252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1586.217,979.3118;Inherit;False;Property;_ScanlineSpeed;Scanline Speed;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2039.586,207.4252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-1587.602,597.6047;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-1596.619,770.0172;Inherit;False;Property;_ScanlineDensity;Scanline Density;6;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-1575.816,885.7166;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-2234.971,-427.9784;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;70c821359fc52be4ba055b7d7f7c3b69;70c821359fc52be4ba055b7d7f7c3b69;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1857.111,-219.3246;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;35;-1579.513,199.9959;Inherit;False;607.7371;257;Fresnel;2;18;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;13;-1854.982,1.662708;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1392.516,922.1135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1391.218,706.3176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-1508.42,-739.0961;Inherit;False;Property;_HoloColor;Holo Color;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1670.296,-523.269;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1529.513,340.8501;Inherit;False;Property;_FresnelPower;Fresnel Power;5;0;Create;True;0;0;0;False;0;False;2;0;0.1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1232.611,822.0164;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1449.792,-72.54149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1260.451,-592.9304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1451.762,-187.9106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1244.55,-413.6815;Inherit;False;Property;_HoloBrightness;Holo Brightness;8;0;Create;True;0;0;0;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;22;-1075.31,823.317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-1161.749,5.602284;Inherit;False;Property;_GlowColor;Glow Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;24;-1227.776,249.9959;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1281.297,-185.6146;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-985.7567,-480.5327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;33;-946.4309,865.7243;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-737.9669,-213.5492;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-939.8378,150.6841;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-529.3758,-21.28184;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-740.1049,378.9804;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Shader_RobotScreen;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;8;0;3;0
WireConnection;8;1;4;0
WireConnection;11;2;9;0
WireConnection;13;0;8;0
WireConnection;12;0;7;0
WireConnection;12;1;6;0
WireConnection;14;0;5;2
WireConnection;14;1;10;0
WireConnection;17;0;9;0
WireConnection;19;0;14;0
WireConnection;19;1;12;0
WireConnection;15;0;11;2
WireConnection;15;1;13;0
WireConnection;23;0;16;0
WireConnection;23;1;17;0
WireConnection;20;0;11;1
WireConnection;20;1;13;0
WireConnection;22;0;19;0
WireConnection;24;3;18;0
WireConnection;21;0;20;0
WireConnection;21;1;15;0
WireConnection;31;0;23;0
WireConnection;31;1;32;0
WireConnection;33;0;22;0
WireConnection;27;0;31;0
WireConnection;27;1;21;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;29;0;27;0
WireConnection;29;1;26;0
WireConnection;30;0;24;0
WireConnection;30;1;33;0
WireConnection;0;2;29;0
WireConnection;0;9;30;0
ASEEND*/
//CHKSM=006DDAB6B788F10F68F6C0788A39A9D5C238117D