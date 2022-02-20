// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/BasicORMShader"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "white" {}
		[NoScaleOffset]_ORM("ORM", 2D) = "white" {}
		_NormalIntensity("NormalIntensity", Float) = 0.5
		_RoughessIntensity("RoughessIntensity", Float) = 1
		[Toggle]_InverseYNormal("Inverse Y Normal", Float) = 0
		_TillingTextureParasite1("TillingTextureParasite", Vector) = (1,1,0,0)
		_ColorAlbedo("ColorAlbedo", Color) = (1,1,1,0)
		[NoScaleOffset]_TextureParasiteAO1("TextureParasite AO", 2D) = "white" {}
		[NoScaleOffset]_TextureMasks1("TextureMasks", 2D) = "white" {}
		[NoScaleOffset]_TextureParasite1("TextureParasite", 2D) = "bump" {}
		[NoScaleOffset]_TextureParasiteAlbedo1("TextureParasiteAlbedo", 2D) = "white" {}
		_SideEffect1("SideEffect", Float) = -4.8
		_ScaleBorderNoise1("ScaleBorderNoise", Float) = 50
		_BorderIntensity1("BorderIntensity", Float) = 2.18
		_SpeedNoiseBorder1("SpeedNoiseBorder", Float) = 0.002
		_ContaminedNormalIntensity1("Contamined Normal Intensity", Float) = 1
		_ContaminedSmoothnessIntensity1("Contamined Smoothness Intensity", Float) = 0
		_AlbedoParasiteIntensity1("AlbedoParasiteIntensity", Float) = 0.51
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _InverseYNormal;
		uniform sampler2D _Normal;
		uniform float _NormalIntensity;
		uniform sampler2D _TextureParasite1;
		uniform float2 _TillingTextureParasite1;
		uniform float _SpeedNoiseBorder1;
		uniform float _ScaleBorderNoise1;
		uniform float3 CenterPosition;
		uniform float RadiusInfection;
		uniform float _SideEffect1;
		uniform float _BorderIntensity1;
		uniform float _ContaminedNormalIntensity1;
		uniform float4 _ColorAlbedo;
		uniform sampler2D _Albedo;
		uniform sampler2D _TextureParasiteAlbedo1;
		uniform float _AlbedoParasiteIntensity1;
		uniform sampler2D _ORM;
		uniform float _RoughessIntensity;
		uniform sampler2D _TextureMasks1;
		uniform float _ContaminedSmoothnessIntensity1;
		uniform sampler2D _TextureParasiteAO1;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal3 = i.uv_texcoord;
			float3 tex2DNode3 = UnpackScaleNormal( tex2D( _Normal, uv_Normal3 ), _NormalIntensity );
			float3 baseNormal120 = (( _InverseYNormal )?( ( tex2DNode3 * float3(1,-1,1) ) ):( tex2DNode3 ));
			float2 TillingTextureParasite114 = _TillingTextureParasite1;
			float2 uv_TexCoord63 = i.uv_texcoord * TillingTextureParasite114;
			float3 ParasiteTexturePatternNormal77 = UnpackNormal( tex2D( _TextureParasite1, uv_TexCoord63 ) );
			float mulTime28 = _Time.y * _SpeedNoiseBorder1;
			float simpleNoise40 = SimpleNoise( ( i.uv_texcoord + mulTime28 )*_ScaleBorderNoise1 );
			float mulTime31 = _Time.y * -_SpeedNoiseBorder1;
			float simpleNoise41 = SimpleNoise( ( i.uv_texcoord + mulTime31 + float2( 0.5,0.3 ) )*_ScaleBorderNoise1 );
			float3 ase_worldPos = i.worldPos;
			float temp_output_5_0_g11 = RadiusInfection;
			float temp_output_9_0_g11 = ( ( distance( ase_worldPos , CenterPosition ) - temp_output_5_0_g11 ) / ( temp_output_5_0_g11 - _SideEffect1 ) );
			float temp_output_44_0 = saturate( temp_output_9_0_g11 );
			float lerpResult48 = lerp( ( simpleNoise40 * simpleNoise41 ) , 1.0 , temp_output_44_0);
			float temp_output_53_0 = ( lerpResult48 * temp_output_44_0 * _BorderIntensity1 );
			float MaxEffectPosition68 = saturate( temp_output_53_0 );
			float3 lerpResult92 = lerp( baseNormal120 , ParasiteTexturePatternNormal77 , MaxEffectPosition68);
			float3 FinalNormalContamined107 = ( lerpResult92 * _ContaminedNormalIntensity1 );
			o.Normal = FinalNormalContamined107;
			float2 uv_Albedo2 = i.uv_texcoord;
			float4 baseAlbedo119 = ( _ColorAlbedo * tex2D( _Albedo, uv_Albedo2 ).r );
			float2 uv_TexCoord56 = i.uv_texcoord * _TillingTextureParasite1;
			float4 ParasiteTexturePatternAlbedo85 = ( tex2D( _TextureParasiteAlbedo1, uv_TexCoord56 ) * _AlbedoParasiteIntensity1 );
			float4 lerpResult102 = lerp( baseAlbedo119 , ParasiteTexturePatternAlbedo85 , MaxEffectPosition68);
			float4 FinalAlbedoContamined108 = lerpResult102;
			o.Albedo = FinalAlbedoContamined108.rgb;
			float2 uv_ORM5 = i.uv_texcoord;
			float4 tex2DNode5 = tex2D( _ORM, uv_ORM5 );
			float baseMetalness123 = tex2DNode5.b;
			o.Metallic = baseMetalness123;
			float baseSmoothness122 = ( 1.0 - ( _RoughessIntensity * tex2DNode5.g ) );
			float2 uv_TexCoord49 = i.uv_texcoord * TillingTextureParasite114;
			float4 tex2DNode51 = tex2D( _TextureMasks1, uv_TexCoord49 );
			float ParasiteTextureSmoothness69 = tex2DNode51.r;
			float lerpResult83 = lerp( baseSmoothness122 , ParasiteTextureSmoothness69 , MaxEffectPosition68);
			float FinalSmoothnessContamined106 = ( lerpResult83 * _ContaminedSmoothnessIntensity1 );
			o.Smoothness = FinalSmoothnessContamined106;
			float baseAmbientOcclusion121 = tex2DNode5.r;
			float4 temp_cast_1 = (baseAmbientOcclusion121).xxxx;
			float2 uv_TexCoord66 = i.uv_texcoord * TillingTextureParasite114;
			float4 ParasiteTexturePatternAO86 = tex2D( _TextureParasiteAO1, uv_TexCoord66 );
			float4 lerpResult103 = lerp( temp_cast_1 , ParasiteTexturePatternAO86 , MaxEffectPosition68);
			float4 FinalAOContamined109 = lerpResult103;
			o.Occlusion = FinalAOContamined109.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
526;73;1314;865;1893.922;-1098.586;1.202832;False;False
Node;AmplifyShaderEditor.CommentaryNode;17;-4664.413,1157.558;Inherit;False;5321.91;3084.88;Parasite;10;25;24;23;22;21;20;19;18;117;118;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1695.703,1194.279;Inherit;False;2308.436;1052.4;Alpha Parasite Circle;26;110;68;59;53;48;47;46;45;44;42;41;40;39;38;37;36;35;34;33;32;31;30;29;28;27;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1373.606,1700.37;Inherit;False;Property;_SpeedNoiseBorder1;SpeedNoiseBorder;15;0;Create;True;0;0;0;False;0;False;0.002;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;27;-1156.244,1946.421;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-4556.811,1211.716;Inherit;False;1412.759;433.0004;Parasite Texture Albedo;8;85;74;70;65;56;54;43;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;32;-963.8748,1491.448;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;31;-918.0916,2028.261;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;30;-912.5418,2130.416;Inherit;False;Constant;_Offset1;Offset;31;0;Create;True;0;0;0;False;0;False;0.5,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;29;-939.8438,1904.556;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;28;-942.1226,1615.153;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-834.3267,1783.102;Inherit;False;Property;_ScaleBorderNoise1;ScaleBorderNoise;13;0;Create;True;0;0;0;False;0;False;50;420.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-694.5098,1920.874;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;35;-1645.703,1407.803;Inherit;False;Global;CenterPosition;CenterPosition;13;0;Create;False;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;37;-1639.96,1244.279;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;43;-4529.811,1469.717;Inherit;False;Property;_TillingTextureParasite1;TillingTextureParasite;6;0;Create;True;0;0;0;False;0;False;1,1;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-725.5293,1573.463;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1346.929,1460.793;Inherit;False;Global;RadiusInfection;RadiusInfection;14;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1258.575,1554.757;Inherit;False;Property;_SideEffect1;SideEffect;12;0;Create;True;0;0;0;False;0;False;-4.8;-4.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-542.7095,1911.794;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;118;-4584.068,2289.724;Inherit;False;1216.58;657.3718;Normal;5;60;63;115;64;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;42;-1229.701,1327.803;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-4223.296,1515.629;Inherit;False;TillingTextureParasite;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;-520.9644,1538.2;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-1525.478,887.8003;Inherit;True;Property;_ORM;ORM;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;117;-4608.55,2997.32;Inherit;False;1546.437;895.6729;ORM;10;113;112;111;73;69;61;51;50;49;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-474.0875,1296.303;Inherit;False;Constant;_Float1;Float 0;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1538.5,229.5;Inherit;True;Property;_Normal;Normal;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-211.9045,1834.169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1495,432.5;Inherit;False;Property;_NormalIntensity;NormalIntensity;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-4547.067,2811.594;Inherit;False;114;TillingTextureParasite;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;44;-1037.702,1375.803;Inherit;False;Invers_Lerp;-1;;11;65c518da2a8456d4585ebf1c79f44daf;1,11,1;3;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-4335.993,3210.613;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-4567.295,1691.796;Inherit;False;1300.938;419.001;Paraiste Texture AO;5;86;81;67;66;116;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;50;-4597.738,3347.825;Inherit;True;Property;_TextureMasks1;TextureMasks;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;9cbf769917ac556408f9140286468c2f;9cbf769917ac556408f9140286468c2f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;8;-1153.978,774.8003;Inherit;False;Property;_RoughessIntensity;RoughessIntensity;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1234.478,895.8003;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-271.9579,1642.07;Inherit;False;Property;_BorderIntensity1;BorderIntensity;14;0;Create;True;0;0;0;False;0;False;2.18;1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;11;-1141.956,432.6747;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;3;-1281.5,226.5;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;48;-301.5628,1334.722;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-4246.172,2664.13;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-4208.811,1330.717;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1541,-24.5;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-151.4509,1409.282;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;54;-4539.812,1270.716;Inherit;True;Property;_TextureParasiteAlbedo1;TextureParasiteAlbedo;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;20c81e09508a5ec4fba65a8abee04320;20c81e09508a5ec4fba65a8abee04320;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-948.2384,345.9343;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-812.9778,831.8003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-4526.406,2011.465;Inherit;False;114;TillingTextureParasite;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;51;-4040.885,3172.384;Inherit;True;Property;_TextureSample13;Texture Sample 12;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;60;-4505.312,2344.921;Inherit;True;Property;_TextureParasite1;TextureParasite;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;0d1508541d32f0840840edcac1f44747;0d1508541d32f0840840edcac1f44747;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-4250.297,1991.797;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-1190.183,-274.6313;Inherit;False;Property;_ColorAlbedo;ColorAlbedo;7;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-4073.76,2351.301;Inherit;True;Property;_TextureSample10;Texture Sample 9;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode;62;-3621.45,3049.279;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;67;-4534.297,1726.796;Inherit;True;Property;_TextureParasiteAO1;TextureParasite AO;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;04acbae515bedef47892a8c7b7cf9711;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ToggleSwitchNode;13;-794.2384,223.9343;Inherit;False;Property;_InverseYNormal;Inverse Y Normal;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;70;-3988.193,1247.589;Inherit;True;Property;_TextureSample5;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;59;65.48911,1316.313;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1281,-24.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;10;-594.9778,723.8003;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-3950.783,1484.854;Inherit;False;Property;_AlbedoParasiteIntensity1;AlbedoParasiteIntensity;18;0;Create;True;0;0;0;False;0;False;0.51;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-300.9436,841.6304;Inherit;False;baseSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-3958.679,1751.669;Inherit;True;Property;_TextureSample6;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;22;-2961.485,2653.527;Inherit;False;1188.5;456.9941;Blend Parasite Smoothness;7;106;94;88;83;78;76;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-3628.783,1287.854;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;224.0234,1303.601;Inherit;False;MaxEffectPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-3398.301,3068.295;Inherit;True;ParasiteTextureSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-3086.342,2140.975;Inherit;False;1106.026;484.5508;Blend Parasite Normal;7;107;105;95;92;91;87;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-3707.285,2354.325;Inherit;False;ParasiteTexturePatternNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-899.3618,-109.3223;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-499.8909,216.9749;Inherit;False;baseNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-3049.342,2282.273;Inherit;False;77;ParasiteTexturePatternNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;24;-3095.155,1217.815;Inherit;False;1337.504;376.6421;Blend Parasite Albedo;5;108;102;100;99;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2869.471,2703.527;Inherit;False;122;baseSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;25;-3110.729,1621.534;Inherit;False;1008.168;478.043;Blend  Parasite AO;5;109;103;101;96;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-2959.559,2190.975;Inherit;False;120;baseNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2991.342,2379.273;Inherit;False;68;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-670.8909,-112.0251;Inherit;False;baseAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2918.485,2794.456;Inherit;False;69;ParasiteTextureSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-3557.35,1765.275;Inherit;False;ParasiteTexturePatternAO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-2863.471,2878.527;Inherit;False;68;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-3413.864,1289.195;Inherit;False;ParasiteTexturePatternAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-358.5414,730.4775;Inherit;False;baseAmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2712.184,2994.521;Inherit;False;Property;_ContaminedSmoothnessIntensity1;Contamined Smoothness Intensity;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-3060.729,1831.84;Inherit;False;86;ParasiteTexturePatternAO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3026.442,1983.576;Inherit;False;68;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2759.898,1488.062;Inherit;False;68;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2822.48,1403.529;Inherit;False;85;ParasiteTexturePatternAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-3042.605,1671.534;Inherit;False;121;baseAmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2713.19,1317.879;Inherit;False;119;baseAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;83;-2513.471,2830.527;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2870.037,2509.526;Inherit;False;Property;_ContaminedNormalIntensity1;Contamined Normal Intensity;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;92;-2592.341,2196.273;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;102;-2395.873,1304.062;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-2286.184,2897.521;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2414.645,2282.285;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;103;-2575.301,1843.168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-2354.561,1906.058;Inherit;False;FinalAOContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-338.3316,1002.298;Inherit;False;baseMetalness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-2084.181,1320.374;Inherit;False;FinalAlbedoContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2972.433,3168.155;Inherit;False;1950.087;1032.72;BlendParasiteHeight;13;79;104;97;90;89;82;80;72;71;58;57;55;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2253.315,2215.105;Inherit;False;FinalNormalContamined;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-2081.985,2895.021;Inherit;False;FinalSmoothnessContamined;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;110;33.82111,1459.463;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;61;-3651.613,3349.994;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-1318.539,3526.986;Inherit;True;FinalHeightParasite;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-2259.594,3327.422;Inherit;True;73;ParasiteTextureMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-189.8558,247.5795;Inherit;False;123;baseMetalness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-268.8558,116.5795;Inherit;False;107;FinalNormalContamined;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1873.813,3414.942;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2882.194,3965.118;Inherit;False;Property;_Speed1;Speed;20;0;Create;True;0;0;0;False;0;False;0.001;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1560.76,3533.777;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-287.8558,348.5795;Inherit;False;106;FinalSmoothnessContamined;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-2265.17,3574.791;Inherit;True;68;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;72;-2465.563,3804.1;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-3412.301,3371.295;Inherit;True;ParasiteTextureMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;112;-3793.613,3487.994;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-3653.036,3164.515;Inherit;True;ParasiteTexturePatternORB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2484.194,4105.12;Inherit;False;Property;_NoiseHeightParasiteScale1;NoiseHeightParasiteScale;21;0;Create;True;0;0;0;False;0;False;174.73;3.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;58;-2806.106,3838.001;Inherit;False;Property;_VectoryDirection1;Vectory Direction;19;0;Create;True;0;0;0;False;0;False;5.3,10;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;89;-1865.431,3702.854;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.42;False;2;FLOAT;3.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;57;-2811.194,3712.119;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;55;-2708.194,3965.118;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-3527.301,3600.295;Inherit;True;ParasiteTextureHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-271.8558,453.5795;Inherit;False;109;FinalAOContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;80;-2170.194,3839.117;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-305.8558,-21.42047;Inherit;False;108;FinalAlbedoContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;243,75;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/BasicORMShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;26;0
WireConnection;31;0;27;0
WireConnection;28;0;26;0
WireConnection;34;0;29;0
WireConnection;34;1;31;0
WireConnection;34;2;30;0
WireConnection;36;0;32;0
WireConnection;36;1;28;0
WireConnection;41;0;34;0
WireConnection;41;1;33;0
WireConnection;42;0;37;0
WireConnection;42;1;35;0
WireConnection;114;0;43;0
WireConnection;40;0;36;0
WireConnection;40;1;33;0
WireConnection;45;0;40;0
WireConnection;45;1;41;0
WireConnection;44;4;42;0
WireConnection;44;5;38;0
WireConnection;44;6;39;0
WireConnection;49;0;115;0
WireConnection;5;0;6;0
WireConnection;3;0;4;0
WireConnection;3;5;7;0
WireConnection;48;0;45;0
WireConnection;48;1;46;0
WireConnection;48;2;44;0
WireConnection;63;0;115;0
WireConnection;56;0;43;0
WireConnection;53;0;48;0
WireConnection;53;1;44;0
WireConnection;53;2;47;0
WireConnection;14;0;3;0
WireConnection;14;1;11;0
WireConnection;9;0;8;0
WireConnection;9;1;5;2
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;66;0;116;0
WireConnection;64;0;60;0
WireConnection;64;1;63;0
WireConnection;62;0;51;1
WireConnection;13;0;3;0
WireConnection;13;1;14;0
WireConnection;70;0;54;0
WireConnection;70;1;56;0
WireConnection;59;0;53;0
WireConnection;2;0;1;0
WireConnection;10;0;9;0
WireConnection;122;0;10;0
WireConnection;81;0;67;0
WireConnection;81;1;66;0
WireConnection;74;0;70;0
WireConnection;74;1;65;0
WireConnection;68;0;59;0
WireConnection;69;0;62;0
WireConnection;77;0;64;0
WireConnection;15;0;16;0
WireConnection;15;1;2;1
WireConnection;120;0;13;0
WireConnection;119;0;15;0
WireConnection;86;0;81;0
WireConnection;85;0;74;0
WireConnection;121;0;5;1
WireConnection;83;0;75;0
WireConnection;83;1;78;0
WireConnection;83;2;76;0
WireConnection;92;0;87;0
WireConnection;92;1;91;0
WireConnection;92;2;84;0
WireConnection;102;0;98;0
WireConnection;102;1;99;0
WireConnection;102;2;100;0
WireConnection;94;0;83;0
WireConnection;94;1;88;0
WireConnection;105;0;92;0
WireConnection;105;1;95;0
WireConnection;103;0;93;0
WireConnection;103;1;101;0
WireConnection;103;2;96;0
WireConnection;109;0;103;0
WireConnection;123;0;5;3
WireConnection;108;0;102;0
WireConnection;107;0;105;0
WireConnection;106;0;94;0
WireConnection;110;0;53;0
WireConnection;110;1;47;0
WireConnection;61;0;51;2
WireConnection;104;0;97;0
WireConnection;90;0;79;0
WireConnection;90;1;82;0
WireConnection;97;0;89;0
WireConnection;97;1;90;0
WireConnection;72;0;57;0
WireConnection;72;2;58;0
WireConnection;72;1;55;0
WireConnection;73;0;61;0
WireConnection;112;0;51;3
WireConnection;113;0;51;0
WireConnection;89;0;80;0
WireConnection;55;0;52;0
WireConnection;111;0;112;0
WireConnection;80;0;72;0
WireConnection;80;1;71;0
WireConnection;0;0;124;0
WireConnection;0;1;125;0
WireConnection;0;3;126;0
WireConnection;0;4;127;0
WireConnection;0;5;128;0
ASEEND*/
//CHKSM=475CE93B1AF2D4782C89EB96F832D7E1573F3FB4