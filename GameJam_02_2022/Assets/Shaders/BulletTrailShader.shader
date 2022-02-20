// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShader/BulletTrailShader"
{
	Properties
	{
		_Tilling("Tilling", Vector) = (0.5,0.47,0,0)
		[NoScaleOffset]_AlphaTrail("AlphaTrail", 2D) = "white" {}
		[HDR]_ColorTrail("ColorTrail", Color) = (0,1.873184,2.639016,0)
		_PowerTrail("PowerTrail", Float) = 1
		_Float0("Float 0", Float) = -0.78
		_SpeedTrail("SpeedTrail", Float) = 1
		_LenghtFadeStart("LenghtFadeStart", Float) = 0.4
		_LenghtFadeRight("LenghtFadeRight", Float) = 0.4
		_LenghtFadeEnd("LenghtFadeEnd", Float) = 0.4
		_LenghtFadeLeft("LenghtFadeLeft", Float) = 0.4
		_ScaleDeformation("ScaleDeformation", Float) = 2
		_StrenghtDeformation("StrenghtDeformation", Range( 0 , 1)) = 0
		_OffsetStart("Offset Start", Vector) = (0,0,0,0)
		_OffsetEnd("Offset End", Vector) = (0,0,0,0)
		_OffsetLeft("Offset Left", Vector) = (0,0,0,0)
		_OffsetRight("Offset Right", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColorTrail;
		uniform sampler2D _AlphaTrail;
		uniform float2 _Tilling;
		uniform float _SpeedTrail;
		uniform float _Float0;
		uniform float _ScaleDeformation;
		uniform float _StrenghtDeformation;
		uniform float _LenghtFadeEnd;
		uniform float2 _OffsetEnd;
		uniform float _LenghtFadeStart;
		uniform float2 _OffsetStart;
		uniform float _LenghtFadeLeft;
		uniform float2 _OffsetLeft;
		uniform float _LenghtFadeRight;
		uniform float2 _OffsetRight;
		uniform float _PowerTrail;


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
			float mulTime6 = _Time.y * -_SpeedTrail;
			float2 appendResult8 = (float2(mulTime6 , _Float0));
			float2 uv_TexCoord5 = i.uv_texcoord * _Tilling + appendResult8;
			float2 temp_cast_0 = (_Time.y).xx;
			float2 uv_TexCoord40 = i.uv_texcoord + temp_cast_0;
			float simplePerlin2D38 = snoise( uv_TexCoord40*_ScaleDeformation );
			simplePerlin2D38 = simplePerlin2D38*0.5 + 0.5;
			float2 UV47 = ( uv_TexCoord5 + ( simplePerlin2D38 * _StrenghtDeformation ) );
			float2 uv_TexCoord13 = i.uv_texcoord + _OffsetEnd;
			float smoothstepResult22 = smoothstep( 0.0 , _LenghtFadeEnd , ( 0.99 - uv_TexCoord13.x ));
			float2 uv_TexCoord27 = i.uv_texcoord + _OffsetStart;
			float smoothstepResult32 = smoothstep( 0.0 , _LenghtFadeStart , ( uv_TexCoord27.x - 0.01 ));
			float2 uv_TexCoord69 = i.uv_texcoord + _OffsetLeft;
			float smoothstepResult77 = smoothstep( 0.0 , _LenghtFadeLeft , ( 0.99 - uv_TexCoord69.y ));
			float2 uv_TexCoord66 = i.uv_texcoord + _OffsetRight;
			float smoothstepResult76 = smoothstep( 0.0 , _LenghtFadeRight , ( uv_TexCoord66.y - 0.01 ));
			float FadeOpacityMask52 = ( saturate( smoothstepResult22 ) * saturate( smoothstepResult32 ) * saturate( smoothstepResult77 ) * saturate( smoothstepResult76 ) );
			float4 temp_output_37_0 = saturate( ( ( tex2D( _AlphaTrail, UV47 ) * FadeOpacityMask52 ) * _PowerTrail ) );
			float4 FinalAlpha54 = temp_output_37_0;
			float4 Emission56 = ( _ColorTrail * FinalAlpha54 );
			o.Emission = Emission56.rgb;
			o.Alpha = FinalAlpha54.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
1920;0;1920;1011;2425.24;-1412.55;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;49;-2050.655,-186.1397;Inherit;False;1581.036;951.3528;;4;46;45;44;47;UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;46;-2000.654,-136.1396;Inherit;False;1039.801;485.8591;Pan Texture;7;2;7;6;12;8;9;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-2054.724,792.7537;Inherit;False;1944.248;1052.314;Fade opacity mask;4;51;50;34;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1997.846,365.2133;Inherit;False;1104;400;Deform UV;6;41;40;39;38;43;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1950.654,185.8603;Inherit;False;Property;_SpeedTrail;SpeedTrail;5;0;Create;True;0;0;0;False;0;False;1;2.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2004.723,1289.516;Inherit;False;1284.86;555.5526;StartFadding;8;32;33;28;31;27;29;30;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-2003.807,842.7537;Inherit;False;1326.379;428.4919;End Fadding;8;22;24;23;14;13;15;26;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;65;-3369.334,807.1209;Inherit;False;1272.066;956.4381;StartFadding;15;67;74;76;78;77;75;73;72;71;70;69;68;66;82;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;80;-1913.204,1536.885;Inherit;False;Property;_OffsetStart;Offset Start;14;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;7;-1755.654,197.8603;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;41;-1947.846,520.213;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;82;-3304.204,1566.885;Inherit;False;Property;_OffsetLeft;Offset Left;16;0;Create;True;0;0;0;False;0;False;0,0;0,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;81;-1932.204,1073.885;Inherit;False;Property;_OffsetEnd;Offset End;15;0;Create;True;0;0;0;False;0;False;0,0;-0.29,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;83;-3295.204,1022.885;Inherit;False;Property;_OffsetRight;Offset Right;17;0;Create;True;0;0;0;False;0;False;0,0;0,0.07;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1953.806,892.7537;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1717.846,459.2133;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1603.654,100.8604;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-3320.549,1354.998;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-3352.767,1237.981;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-3226.549,1514.997;Inherit;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1859.806,1052.753;Inherit;False;Constant;_End;End;4;0;Create;True;0;0;0;False;0;False;0.99;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1701.846,582.213;Inherit;False;Property;_ScaleDeformation;ScaleDeformation;10;0;Create;True;0;0;0;False;0;False;2;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1749.633,1493.56;Inherit;False;Constant;_Start;Start;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-3319.334,900.3011;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1887.342,1393.177;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1565.214,241.7194;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;-0.78;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1421.779,1050.245;Inherit;False;Constant;_Float4;Float 4;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1383.654,78.86035;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;9;-1541.654,-86.13965;Inherit;False;Property;_Tilling;Tilling;0;0;Create;True;0;0;0;False;0;False;0.5,0.47;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;24;-1459.779,1155.245;Inherit;False;Property;_LenghtFadeEnd;LenghtFadeEnd;8;0;Create;True;0;0;0;False;0;False;0.4;4.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1425.846,649.213;Inherit;False;Property;_StrenghtDeformation;StrenghtDeformation;11;0;Create;True;0;0;0;False;0;False;0;0.515;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-1381.846,427.2133;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-1671.806,948.7537;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1534.533,1729.067;Inherit;False;Property;_LenghtFadeStart;LenghtFadeStart;6;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;-3201.781,1121.887;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-3038.549,1410.998;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2861.144,1141.673;Inherit;False;Constant;_Float6;Float 6;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2788.523,1512.489;Inherit;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-1561.632,1389.56;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2826.523,1617.489;Inherit;False;Property;_LenghtFadeLeft;LenghtFadeLeft;9;0;Create;True;0;0;0;False;0;False;0.4;0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1496.533,1624.066;Inherit;False;Constant;_min;min;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2899.144,1246.674;Inherit;False;Property;_LenghtFadeRight;LenghtFadeRight;7;0;Create;True;0;0;0;False;0;False;0.4;0.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;76;-2620.697,1126.519;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;32;-1194.369,1349.706;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1202.855,3.860415;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;77;-2495.34,1398.249;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1055.846,415.2133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-1128.596,936.0047;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;79;-2242.173,1386.703;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;-875.429,924.4586;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;78;-2356.533,1128.673;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-833.8918,255.6992;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;33;-917.8611,1339.516;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2079.03,1887.187;Inherit;False;1468.924;403.9717;Texture Alpha;11;37;62;63;64;35;36;25;53;4;3;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-599.3295,1211.073;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-693.6195,253.3095;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2060.891,1937.678;Inherit;True;Property;_AlphaTrail;AlphaTrail;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;04acbae515bedef47892a8c7b7cf9711;a6e56e7ab3f9ab849a8bd961b68750c9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-349.4748,1211.607;Inherit;False;FadeOpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-1951.709,2155.026;Inherit;False;47;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1627.561,2114.013;Inherit;False;52;FadeOpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1768.605,1944.944;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1450.873,1930.947;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1384.261,2189.312;Inherit;False;Property;_PowerTrail;PowerTrail;3;0;Create;True;0;0;0;False;0;False;1;3.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1176.781,2078.634;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;37;-1025.706,1948.659;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;60;-1406.415,2315.278;Inherit;False;798.8226;357.3562;Emission;4;11;10;57;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-535.1075,1952.187;Inherit;False;FinalAlpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;10;-1356.415,2365.278;Inherit;False;Property;_ColorTrail;ColorTrail;2;1;[HDR];Create;True;0;0;0;False;0;False;0,1.873184,2.639016,0;4.768628,24.3451,47.93726,0.4745098;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1310.342,2556.634;Inherit;False;54;FinalAlpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1009.834,2375.505;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-827.5314,2369.258;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;10.95915,1092.895;Inherit;False;54;FinalAlpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;-684.0897,2049.558;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;13.95915,917.8949;Inherit;False;56;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-876.7607,2187.707;Inherit;False;Property;_smoothstepMax;smoothstepMax;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-908.7607,2079.707;Inherit;False;Property;_SmoothstepMin;SmoothstepMin;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;267.1064,883.1473;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;MyShader/BulletTrailShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;2;0
WireConnection;13;1;81;0
WireConnection;40;1;41;0
WireConnection;6;0;7;0
WireConnection;69;1;82;0
WireConnection;66;1;83;0
WireConnection;27;1;80;0
WireConnection;8;0;6;0
WireConnection;8;1;12;0
WireConnection;38;0;40;0
WireConnection;38;1;39;0
WireConnection;15;0;14;0
WireConnection;15;1;13;1
WireConnection;74;0;66;2
WireConnection;74;1;67;0
WireConnection;70;0;68;0
WireConnection;70;1;69;2
WireConnection;31;0;27;1
WireConnection;31;1;28;0
WireConnection;76;0;74;0
WireConnection;76;1;75;0
WireConnection;76;2;73;0
WireConnection;32;0;31;0
WireConnection;32;1;29;0
WireConnection;32;2;30;0
WireConnection;5;0;9;0
WireConnection;5;1;8;0
WireConnection;77;0;70;0
WireConnection;77;1;71;0
WireConnection;77;2;72;0
WireConnection;42;0;38;0
WireConnection;42;1;43;0
WireConnection;22;0;15;0
WireConnection;22;1;23;0
WireConnection;22;2;24;0
WireConnection;79;0;77;0
WireConnection;26;0;22;0
WireConnection;78;0;76;0
WireConnection;44;0;5;0
WireConnection;44;1;42;0
WireConnection;33;0;32;0
WireConnection;34;0;26;0
WireConnection;34;1;33;0
WireConnection;34;2;79;0
WireConnection;34;3;78;0
WireConnection;47;0;44;0
WireConnection;52;0;34;0
WireConnection;4;0;3;0
WireConnection;4;1;48;0
WireConnection;25;0;4;0
WireConnection;25;1;53;0
WireConnection;35;0;25;0
WireConnection;35;1;36;0
WireConnection;37;0;35;0
WireConnection;54;0;37;0
WireConnection;11;0;10;0
WireConnection;11;1;57;0
WireConnection;56;0;11;0
WireConnection;62;0;37;0
WireConnection;62;1;63;0
WireConnection;62;2;64;0
WireConnection;0;2;59;0
WireConnection;0;9;58;0
ASEEND*/
//CHKSM=4284D036BB19FE1D44C4BE44D2908CEE4E571F62