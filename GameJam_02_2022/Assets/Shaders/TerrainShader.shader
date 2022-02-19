// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/TerrainShader"
{
	Properties
	{
		_SideEffect1("SideEffect", Float) = 0
		[NoScaleOffset]_AlbedoGrass("AlbedoGrass", 2D) = "white" {}
		_CenterPosition1("CenterPosition", Vector) = (0,0,0,0)
		_RadiusInfection("RadiusInfection", Float) = 0
		[NoScaleOffset]_AlbedoRock("AlbedoRock", 2D) = "white" {}
		[NoScaleOffset]_AlbedoDirt("AlbedoDirt", 2D) = "white" {}
		[NoScaleOffset]_AlbedoGravel("AlbedoGravel", 2D) = "white" {}
		[NoScaleOffset]_SplatMap("SplatMap", 2D) = "white" {}
		[NoScaleOffset]_MaskGrassTexture("MaskGrassTexture", 2D) = "white" {}
		[NoScaleOffset]_MaskRockTexture("MaskRockTexture", 2D) = "white" {}
		[NoScaleOffset]_MaskGravelTexture("MaskGravelTexture", 2D) = "white" {}
		[NoScaleOffset]_MaskDirtTexture("MaskDirtTexture", 2D) = "white" {}
		_TillingGrass("TillingGrass", Vector) = (1,1,0,0)
		_TillingRock("TillingRock", Vector) = (1,1,0,0)
		_TillingDirt("TillingDirt", Vector) = (1,1,0,0)
		_TillingGravel("TillingGravel", Vector) = (1,1,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_ScaleBorderNoise("ScaleBorderNoise", Float) = 50
		_BorderIntensity("BorderIntensity", Float) = 1
		_SpeedNoiseBorder("SpeedNoiseBorder", Float) = 1
		_ParasiteCOlor("ParasiteCOlor", Color) = (1,0,0.9151793,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _AlbedoRock;
		uniform float2 _TillingRock;
		uniform sampler2D _AlbedoGrass;
		uniform float2 _TillingGrass;
		uniform sampler2D _SplatMap;
		uniform sampler2D _AlbedoDirt;
		uniform float2 _TillingDirt;
		uniform sampler2D _AlbedoGravel;
		uniform float2 _TillingGravel;
		uniform float _SpeedNoiseBorder;
		uniform float _ScaleBorderNoise;
		uniform float3 _CenterPosition1;
		uniform float _RadiusInfection;
		uniform float _SideEffect1;
		uniform float _BorderIntensity;
		uniform float4 _ParasiteCOlor;
		uniform sampler2D _MaskRockTexture;
		uniform sampler2D _MaskGrassTexture;
		uniform sampler2D _MaskDirtTexture;
		uniform sampler2D _MaskGravelTexture;
		uniform float _Smoothness;


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
			float2 uv_TexCoord29 = i.uv_texcoord * _TillingRock;
			float4 AlbedoRock32 = tex2D( _AlbedoRock, uv_TexCoord29 );
			float2 uv_TexCoord3 = i.uv_texcoord * _TillingGrass;
			float4 AlbedoGrass5 = tex2D( _AlbedoGrass, uv_TexCoord3 );
			float2 uv_SplatMap6 = i.uv_texcoord;
			float4 tex2DNode6 = tex2D( _SplatMap, uv_SplatMap6 );
			float MaskGrass8 = tex2DNode6.g;
			float4 lerpResult18 = lerp( AlbedoRock32 , AlbedoGrass5 , MaskGrass8);
			float2 uv_TexCoord61 = i.uv_texcoord * _TillingDirt;
			float4 AlbedoDirt49 = tex2D( _AlbedoDirt, uv_TexCoord61 );
			float MaskDirt10 = tex2DNode6.b;
			float4 lerpResult78 = lerp( lerpResult18 , AlbedoDirt49 , MaskDirt10);
			float2 uv_TexCoord67 = i.uv_texcoord * _TillingGravel;
			float4 AlbedoGravel70 = tex2D( _AlbedoGravel, uv_TexCoord67 );
			float MaskGravel9 = tex2DNode6.r;
			float4 lerpResult81 = lerp( lerpResult78 , AlbedoGravel70 , MaskGravel9);
			float4 FinalAlbedo21 = lerpResult81;
			float mulTime173 = _Time.y * _SpeedNoiseBorder;
			float simpleNoise162 = SimpleNoise( ( i.uv_texcoord + mulTime173 )*_ScaleBorderNoise );
			float mulTime177 = _Time.y * -_SpeedNoiseBorder;
			float simpleNoise182 = SimpleNoise( ( i.uv_texcoord + mulTime177 + float2( 0.5,0.3 ) )*_ScaleBorderNoise );
			float3 ase_worldPos = i.worldPos;
			float temp_output_5_0_g2 = _RadiusInfection;
			float temp_output_9_0_g2 = ( ( distance( ase_worldPos , _CenterPosition1 ) - temp_output_5_0_g2 ) / ( temp_output_5_0_g2 - _SideEffect1 ) );
			float temp_output_142_0 = saturate( temp_output_9_0_g2 );
			float lerpResult164 = lerp( ( simpleNoise162 * simpleNoise182 ) , 1.0 , temp_output_142_0);
			float temp_output_167_0 = ( lerpResult164 * temp_output_142_0 * _BorderIntensity );
			float MaxEffectPosition144 = saturate( temp_output_167_0 );
			float Alpha151 = MaxEffectPosition144;
			float4 AlbedoParasite150 = ( MaxEffectPosition144 * Alpha151 * _ParasiteCOlor );
			float4 lerpResult155 = lerp( FinalAlbedo21 , AlbedoParasite150 , AlbedoParasite150);
			float4 FinalAlbedoContamined158 = lerpResult155;
			o.Albedo = FinalAlbedoContamined158.rgb;
			float4 tex2DNode37 = tex2D( _MaskRockTexture, uv_TexCoord29 );
			float SmoothnessRock35 = tex2DNode37.a;
			float4 tex2DNode11 = tex2D( _MaskGrassTexture, uv_TexCoord3 );
			float SmoothnessGrass16 = tex2DNode11.a;
			float lerpResult101 = lerp( SmoothnessRock35 , SmoothnessGrass16 , MaskGrass8);
			float4 tex2DNode52 = tex2D( _MaskDirtTexture, uv_TexCoord61 );
			float SmoothnessDirt54 = tex2DNode52.a;
			float lerpResult104 = lerp( lerpResult101 , SmoothnessDirt54 , MaskDirt10);
			float4 tex2DNode65 = tex2D( _MaskGravelTexture, uv_TexCoord67 );
			float SmoothnessGravel75 = tex2DNode65.a;
			float lerpResult105 = lerp( lerpResult104 , SmoothnessGravel75 , MaskGravel9);
			float FinalSmoothness109 = lerpResult105;
			o.Smoothness = ( FinalSmoothness109 * _Smoothness );
			float AmbientOcclusionRock34 = tex2DNode37.g;
			float AmbientOcclusionGrass14 = tex2DNode11.g;
			float lerpResult90 = lerp( AmbientOcclusionRock34 , AmbientOcclusionGrass14 , MaskGrass8);
			float AmbientOcclusionDirt53 = tex2DNode52.g;
			float lerpResult94 = lerp( lerpResult90 , AmbientOcclusionDirt53 , MaskDirt10);
			float AmbientOcclusionGravel73 = tex2DNode65.g;
			float lerpResult95 = lerp( lerpResult94 , AmbientOcclusionGravel73 , MaskGravel9);
			float FinalAmbientOcclusion96 = lerpResult95;
			o.Occlusion = FinalAmbientOcclusion96;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
0;0;1920;1011;365.4117;-5625.824;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;132;-214.2145,4172.016;Inherit;False;2308.436;1052.4;Alpha Parasite Circle;25;169;168;144;170;167;164;142;162;165;137;138;175;139;163;134;171;173;133;172;177;178;179;181;182;184;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;172;186.8812,4625.106;Inherit;False;Property;_SpeedNoiseBorder;SpeedNoiseBorder;25;0;Create;True;0;0;0;False;0;False;1;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;184;325.2434,4924.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;171;517.6127,4469.186;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;177;563.3943,5005.994;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;178;541.6434,4882.29;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;181;568.9449,5108.149;Inherit;False;Constant;_Offset;Offset;31;0;Create;True;0;0;0;False;0;False;0.5,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;173;539.3636,4592.89;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;134;-164.2145,4385.541;Inherit;False;Property;_CenterPosition1;CenterPosition;4;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;175;755.9568,4551.201;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;133;-158.4715,4222.016;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;179;786.9768,4898.608;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;163;647.1596,4760.838;Inherit;False;Property;_ScaleBorderNoise;ScaleBorderNoise;23;0;Create;True;0;0;0;False;0;False;50;420.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;229.5584,4449.531;Inherit;False;Property;_RadiusInfection;RadiusInfection;5;0;Create;False;0;0;0;False;0;False;0;83.92754;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;162;960.5214,4515.938;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;137;251.7863,4305.541;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;222.9125,4532.495;Inherit;False;Property;_SideEffect1;SideEffect;2;0;Create;True;0;0;0;False;0;False;0;-4.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;182;938.7769,4889.528;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;1007.399,4274.041;Inherit;False;Constant;_Float0;Float 0;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1695.964,1113.042;Inherit;False;1129.922;1179.833;Rock;8;29;28;43;27;32;31;30;128;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;142;443.7855,4353.541;Inherit;False;Invers_Lerp;-1;;2;65c518da2a8456d4585ebf1c79f44daf;1,11,1;3;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1699.203,-85.60378;Inherit;False;1139.513;1144.976;Grass;8;2;1;24;5;3;4;42;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;1249.741,4813.558;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-1603.462,182.3962;Inherit;False;Property;_TillingGrass;TillingGrass;14;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;169;1209.529,4619.806;Inherit;False;Property;_BorderIntensity;BorderIntensity;24;0;Create;True;0;0;0;False;0;False;1;1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1575.603,-676.7692;Inherit;False;975.1481;383.9352;Mask splat map;6;7;6;8;17;10;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1700.21,2345.333;Inherit;False;1129.922;1179.833;Dirt;8;61;60;59;50;49;48;47;129;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;28;-1649.223,1380.041;Inherit;False;Property;_TillingRock;TillingRock;15;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;164;1179.924,4312.46;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;1330.036,4387.02;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1453.462,-35.60377;Inherit;True;Property;_AlbedoGrass;AlbedoGrass;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;4302b9a817cd07e478653a409bfe6000;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1443.462,179.3962;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;60;-1653.469,2612.333;Inherit;False;Property;_TillingDirt;TillingDirt;16;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;62;-1704.715,3556.895;Inherit;False;1129.922;1179.833;Gravel;8;77;70;69;68;67;64;63;130;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-1525.603,-575.1351;Inherit;True;Property;_SplatMap;SplatMap;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;a08ef57615cfe764fb6bc38911e957bc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1489.223,1377.041;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;30;-1450.223,1163.041;Inherit;True;Property;_AlbedoRock;AlbedoRock;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;e2743a02d56b8034cad620884cbad28a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;170;1546.976,4294.051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1649.203,388.7201;Inherit;False;979.5002;399;Mask ;6;15;14;16;12;11;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-1210.462,161.3962;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;69;-1657.974,3823.894;Inherit;False;Property;_TillingGravel;TillingGravel;17;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-1493.469,2609.333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;27;-1645.964,1587.365;Inherit;False;979.5002;399;Mask ;6;38;37;36;35;34;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;31;-1207.223,1360.041;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;47;-1454.469,2395.333;Inherit;True;Property;_AlbedoDirt;AlbedoDirt;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;81f2a88291c6ba44bb27fc92113f6483;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;6;-1270.619,-569.8563;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-860.2215,1360.041;Inherit;False;AlbedoRock;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-828.2784,-555.7682;Inherit;False;MaskGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-367.977,677.8135;Inherit;False;1384.725;613.0347;Albedo blending;11;19;39;20;80;18;79;82;83;78;81;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;68;-1458.974,3606.895;Inherit;True;Property;_AlbedoGravel;AlbedoGravel;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;baa9dd568cea8384ab7a41a4751ade93;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1595.964,1698.865;Inherit;True;Property;_MaskRockTexture;MaskRockTexture;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;9268c92b6f62b1d4ab278bfcba329876;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;48;-1211.469,2592.333;Inherit;True;Property;_TextureSample7;Texture Sample 7;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;1705.51,4281.339;Inherit;False;MaxEffectPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1650.21,2819.657;Inherit;False;979.5002;399;Mask ;6;56;55;54;53;52;51;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-863.4617,161.3962;Inherit;False;AlbedoGrass;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1599.203,500.2201;Inherit;True;Property;_MaskGrassTexture;MaskGrassTexture;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;3ff6f87c551189b47ae882fd77943ed9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;143;-307.4802,5386.607;Inherit;False;1399.364;972.6797;Blend;13;158;155;153;152;154;150;149;148;151;147;159;160;187;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-1497.974,3820.894;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-1215.974,3803.894;Inherit;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-826.2784,-479.7677;Inherit;False;MaskDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;55;-1600.21,2931.157;Inherit;True;Property;_MaskDirtTexture;MaskDirtTexture;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;7b561dcae4e75b44ba94aa84b224557d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;37;-1352.964,1698.865;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-1356.203,500.2201;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-864.4686,2592.333;Inherit;False;AlbedoDirt;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-317.977,728.3656;Inherit;False;32;AlbedoRock;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-310.4267,990.8134;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-313.4267,875.8134;Inherit;False;5;AlbedoGrass;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;64;-1654.715,4031.218;Inherit;False;979.5002;399;Mask ;6;75;74;73;72;71;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;285.5017,5442.607;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-1604.715,4142.718;Inherit;True;Property;_MaskGravelTexture;MaskGravelTexture;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;5ba0118310205464f9b8c2ab072ece29;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;18;-24.4265,727.8135;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-15.49958,997.7936;Inherit;False;49;AlbedoDirt;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-941.7019,671.7199;Inherit;False;SmoothnessGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-826.2784,-626.7689;Inherit;False;MaskGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;98;-357.2249,2081.032;Inherit;False;1384.725;613.0347;Albedo blending;11;109;108;107;106;105;104;103;102;101;100;99;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-938.4617,1870.365;Inherit;False;SmoothnessRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-868.9741,3803.894;Inherit;False;AlbedoGravel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;0.4752355,1106.955;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1357.21,2931.157;Inherit;True;Property;_TextureSample8;Texture Sample 8;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;734.5018,5445.607;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-940.4617,1716.365;Inherit;False;AmbientOcclusionRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;296.1047,5576.87;Inherit;False;151;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-307.2249,2131.584;Inherit;False;35;SmoothnessRock;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-297.6746,2212.032;Inherit;False;16;SmoothnessGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;245.4217,915.2551;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-942.7089,3102.657;Inherit;False;SmoothnessDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-299.6745,2394.032;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;335.9452,1081.662;Inherit;False;70;AlbedoGravel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;65;-1361.715,4142.718;Inherit;True;Property;_TextureSample11;Texture Sample 11;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;85;-364.4455,1387.588;Inherit;False;1384.725;613.0347;Albedo blending;11;96;95;94;93;92;91;90;89;88;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-943.7019,517.7201;Inherit;False;AmbientOcclusionGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;346.5952,1174.848;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;187;120.2697,5771.963;Inherit;False;Property;_ParasiteCOlor;ParasiteCOlor;26;0;Create;True;0;0;0;False;0;False;1,0,0.9151793,0;1,0,0.9151793,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-947.2144,4314.218;Inherit;False;SmoothnessGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-314.4455,1438.14;Inherit;False;34;AmbientOcclusionRock;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-944.7089,2948.657;Inherit;False;AmbientOcclusionDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-314.8952,1524.588;Inherit;False;14;AmbientOcclusionGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-53.74738,2395.012;Inherit;False;54;SmoothnessDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-306.8952,1700.588;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;546.9714,5519.801;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;11.2274,2510.173;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;101;-13.67437,2131.032;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;81;566.249,961.8493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;760.7454,5518.737;Inherit;False;AlbedoParasite;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;104;256.1736,2318.473;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;792.7485,952.4474;Inherit;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;4.006741,1816.729;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;-20.89503,1437.588;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-949.2144,4160.218;Inherit;False;AmbientOcclusionGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;357.3472,2578.067;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-60.96806,1701.568;Inherit;False;53;AmbientOcclusionDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;272.6972,2477.88;Inherit;False;75;SmoothnessGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;267.2567,5942.64;Inherit;False;21;FinalAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;153.5127,6213.026;Inherit;False;150;AlbedoParasite;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;350.1266,1884.623;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;577.0011,2365.068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;248.953,1625.029;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;128.4198,6023.683;Inherit;False;150;AlbedoParasite;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;265.4766,1784.436;Inherit;False;73;AmbientOcclusionGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;155;517.5607,6005.275;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;95;569.7806,1671.624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;770.5005,2366.666;Inherit;False;FinalSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;743.3009,5987.165;Inherit;False;FinalAlbedoContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;763.28,1673.222;Inherit;False;FinalAmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;-354.9986,2754.259;Inherit;False;1384.725;613.0347;Albedo blending;11;125;124;123;122;121;120;119;118;117;116;115;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;275.9035,206.9968;Inherit;False;109;FinalSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-238.0655,3712.892;Inherit;False;1255.759;424.0004;Parasite Texture;5;145;141;140;136;135;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;113;212.9411,286.3007;Inherit;False;Property;_Smoothness;Smoothness;18;0;Create;True;0;0;0;False;0;False;1;0.147;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;136;-20.4507,3768.584;Inherit;True;Property;_TextureParasite1;TextureParasite;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;7f552bff8573ec64492090f6f4415ca1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-945.2144,4081.218;Inherit;False;MetalnessGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;467.9277,79.18179;Inherit;False;125;FinalNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;792.6942,3868.064;Inherit;False;ParasiteTexturePattern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;491.9411,217.3007;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;141;327.5445,3865.765;Inherit;True;Property;_TextureSample14;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-939.7019,438.7201;Inherit;False;MetalnessGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;229.0346,421.0259;Inherit;False;96;FinalAmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;397.2046,0.6100464;Inherit;False;158;FinalAlbedoContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-936.4617,1637.365;Inherit;False;MetalnessRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1636.183,4619.258;Inherit;False;Property;_ScaleNormalGravel;ScaleNormalGravel;22;0;Create;True;0;0;0;False;0;False;0;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;135;-216.0655,3962.893;Inherit;False;Property;_TillingTextureParasite1;TillingTextureParasite;0;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-943.7019,595.7199;Inherit;False;HeightGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1627.391,3417.953;Inherit;False;Property;_ScaleNormalDirt;ScaleNormalDirt;21;0;Create;True;0;0;0;False;0;False;0;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;168;1515.308,4437.201;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;540.5886,6154.917;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1648.711,2175.974;Inherit;False;Property;_ScaleNormalRock;ScaleNormalRock;20;0;Create;True;0;0;0;False;0;False;0;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;6.933504,3954.893;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-944.7089,3026.657;Inherit;False;HeightDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-940.5098,821.1891;Inherit;False;NormalGrass;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;274.9236,3151.106;Inherit;False;77;NormalGravel;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-988.5628,4506.088;Inherit;False;NormalGravel;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-943.8102,2056.236;Inherit;False;NormalRock;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-297.4483,3067.259;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-295.4484,2885.259;Inherit;False;42;NormalGrass;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1013.057,3284.527;Inherit;False;NormalDirt;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-304.9987,2804.811;Inherit;False;43;NormalRock;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-51.52115,3068.239;Inherit;False;59;NormalDirt;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1653.724,935.8429;Inherit;False;Property;_ScaleNormalGrass;ScaleNormalGrass;19;0;Create;True;0;0;0;False;0;False;0;0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;118;-11.44815,2804.259;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;13.45361,3183.4;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;359.5736,3251.293;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;123;258.4,2991.699;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;124;579.2274,3038.295;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;772.7267,3039.893;Inherit;False;FinalNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-940.7089,2869.657;Inherit;False;MetalnessDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-940.4617,1794.365;Inherit;False;HeightRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-949.2144,4238.218;Inherit;False;HeightGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-824.4565,-408.8326;Inherit;False;RockMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;114.1326,6115.945;Inherit;False;145;ParasiteTexturePattern;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;789,7;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/TerrainShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;184;0;172;0
WireConnection;177;0;184;0
WireConnection;173;0;172;0
WireConnection;175;0;171;0
WireConnection;175;1;173;0
WireConnection;179;0;178;0
WireConnection;179;1;177;0
WireConnection;179;2;181;0
WireConnection;162;0;175;0
WireConnection;162;1;163;0
WireConnection;137;0;133;0
WireConnection;137;1;134;0
WireConnection;182;0;179;0
WireConnection;182;1;163;0
WireConnection;142;4;137;0
WireConnection;142;5;138;0
WireConnection;142;6;139;0
WireConnection;183;0;162;0
WireConnection;183;1;182;0
WireConnection;164;0;183;0
WireConnection;164;1;165;0
WireConnection;164;2;142;0
WireConnection;167;0;164;0
WireConnection;167;1;142;0
WireConnection;167;2;169;0
WireConnection;3;0;4;0
WireConnection;29;0;28;0
WireConnection;170;0;167;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;61;0;60;0
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;6;0;7;0
WireConnection;32;0;31;0
WireConnection;8;0;6;2
WireConnection;48;0;47;0
WireConnection;48;1;61;0
WireConnection;144;0;170;0
WireConnection;5;0;2;0
WireConnection;67;0;69;0
WireConnection;63;0;68;0
WireConnection;63;1;67;0
WireConnection;10;0;6;3
WireConnection;37;0;36;0
WireConnection;37;1;29;0
WireConnection;11;0;12;0
WireConnection;11;1;3;0
WireConnection;49;0;48;0
WireConnection;18;0;39;0
WireConnection;18;1;20;0
WireConnection;18;2;19;0
WireConnection;16;0;11;4
WireConnection;9;0;6;1
WireConnection;35;0;37;4
WireConnection;70;0;63;0
WireConnection;52;0;55;0
WireConnection;52;1;61;0
WireConnection;151;0;147;0
WireConnection;34;0;37;2
WireConnection;78;0;18;0
WireConnection;78;1;80;0
WireConnection;78;2;79;0
WireConnection;54;0;52;4
WireConnection;65;0;71;0
WireConnection;65;1;67;0
WireConnection;14;0;11;2
WireConnection;75;0;65;4
WireConnection;53;0;52;2
WireConnection;149;0;147;0
WireConnection;149;1;148;0
WireConnection;149;2;187;0
WireConnection;101;0;100;0
WireConnection;101;1;106;0
WireConnection;101;2;99;0
WireConnection;81;0;78;0
WireConnection;81;1;83;0
WireConnection;81;2;82;0
WireConnection;150;0;149;0
WireConnection;104;0;101;0
WireConnection;104;1;107;0
WireConnection;104;2;102;0
WireConnection;21;0;81;0
WireConnection;90;0;87;0
WireConnection;90;1;88;0
WireConnection;90;2;86;0
WireConnection;73;0;65;2
WireConnection;105;0;104;0
WireConnection;105;1;108;0
WireConnection;105;2;103;0
WireConnection;94;0;90;0
WireConnection;94;1;89;0
WireConnection;94;2;91;0
WireConnection;155;0;153;0
WireConnection;155;1;154;0
WireConnection;155;2;152;0
WireConnection;95;0;94;0
WireConnection;95;1;93;0
WireConnection;95;2;92;0
WireConnection;109;0;105;0
WireConnection;158;0;155;0
WireConnection;96;0;95;0
WireConnection;72;0;65;1
WireConnection;145;0;141;0
WireConnection;112;0;110;0
WireConnection;112;1;113;0
WireConnection;141;0;136;0
WireConnection;141;1;140;0
WireConnection;13;0;11;1
WireConnection;38;0;37;1
WireConnection;15;0;11;3
WireConnection;168;0;167;0
WireConnection;168;1;169;0
WireConnection;160;0;154;0
WireConnection;140;0;135;0
WireConnection;51;0;52;3
WireConnection;118;0;116;0
WireConnection;118;1;115;0
WireConnection;118;2;117;0
WireConnection;123;0;118;0
WireConnection;123;1;120;0
WireConnection;123;2;119;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;124;2;121;0
WireConnection;125;0;124;0
WireConnection;56;0;52;1
WireConnection;33;0;37;3
WireConnection;74;0;65;3
WireConnection;17;0;6;4
WireConnection;0;0;22;0
WireConnection;0;4;112;0
WireConnection;0;5;97;0
ASEEND*/
//CHKSM=3EC2CD91EAE57CFD10A536081D492BB82AE91D4B