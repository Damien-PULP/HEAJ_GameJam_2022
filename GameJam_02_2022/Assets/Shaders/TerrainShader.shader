// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/TerrainShader_02"
{
	Properties
	{
		_TillingTextureParasite("TillingTextureParasite", Vector) = (1,1,0,0)
		[NoScaleOffset]_TextureParasiteAO("TextureParasite AO", 2D) = "white" {}
		[NoScaleOffset]_TextureMasks("TextureMasks", 2D) = "white" {}
		[NoScaleOffset]_TextureParasite("TextureParasite", 2D) = "bump" {}
		[NoScaleOffset]_TextureParasiteAlbedo("TextureParasiteAlbedo", 2D) = "white" {}
		_SideEffect("SideEffect", Float) = 0
		[NoScaleOffset]_AlbedoGrass("AlbedoGrass", 2D) = "white" {}
		_CenterPositionWorld("CenterPosition", Vector) = (0,0,0,0)
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
		_ScaleNormalGrass("ScaleNormalGrass", Float) = 1
		_ScaleNormalRock("ScaleNormalRock", Float) = 1
		_ScaleNormalDirt("ScaleNormalDirt", Float) = 1
		_ScaleNormalGravel("ScaleNormalGravel", Float) = 1
		_ScaleBorderNoise("ScaleBorderNoise", Float) = 50
		_BorderIntensity("BorderIntensity", Float) = 1
		_SpeedNoiseBorder("SpeedNoiseBorder", Float) = 1
		_ContaminedNormalIntensity("Contamined Normal Intensity", Float) = 1
		_ContaminedSmoothnessIntensity("Contamined Smoothness Intensity", Float) = 0
		_Tesselation("Tesselation", Range( 0 , 32)) = 0
		_AlbedoParasiteIntensity("AlbedoParasiteIntensity", Float) = 0.37
		_Vector4("Vector 4", Vector) = (0,0,0,0)
		_Float2("Float 2", Float) = 0
		_NoiseHeightParasiteScale("NoiseHeightParasiteScale", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _MaskRockTexture;
		uniform float2 _TillingRock;
		uniform float _ScaleNormalRock;
		uniform sampler2D _MaskGrassTexture;
		uniform float2 _TillingGrass;
		uniform float _ScaleNormalGrass;
		uniform sampler2D _SplatMap;
		uniform sampler2D _MaskDirtTexture;
		uniform float2 _TillingDirt;
		uniform float _ScaleNormalDirt;
		uniform sampler2D _MaskGravelTexture;
		uniform float2 _TillingGravel;
		uniform float _ScaleNormalGravel;
		uniform sampler2D _TextureParasite;
		uniform float2 _TillingTextureParasite;
		uniform float _SpeedNoiseBorder;
		uniform float _ScaleBorderNoise;
		uniform float3 _CenterPositionWorld;
		uniform float _RadiusInfection;
		uniform float _SideEffect;
		uniform float _BorderIntensity;
		uniform float _ContaminedNormalIntensity;
		uniform sampler2D _AlbedoRock;
		uniform sampler2D _AlbedoGrass;
		uniform sampler2D _AlbedoDirt;
		uniform sampler2D _AlbedoGravel;
		uniform sampler2D _TextureParasiteAlbedo;
		uniform float _AlbedoParasiteIntensity;
		uniform float _Float2;
		uniform float2 _Vector4;
		uniform float _NoiseHeightParasiteScale;
		uniform sampler2D _TextureMasks;
		uniform float _ContaminedSmoothnessIntensity;
		uniform float _Smoothness;
		uniform sampler2D _TextureParasiteAO;
		uniform float _Tesselation;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (_Tesselation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord29 = i.uv_texcoord * _TillingRock;
			float4 tex2DNode37 = tex2D( _MaskRockTexture, uv_TexCoord29 );
			float temp_output_1_0_g7 = tex2DNode37.r;
			float temp_output_2_0_g7 = tex2DNode37.b;
			float dotResult3_g7 = dot( temp_output_1_0_g7 , temp_output_2_0_g7 );
			float3 appendResult8_g7 = (float3(temp_output_1_0_g7 , temp_output_2_0_g7 , ( _ScaleNormalRock * sqrt( ( 1.0 - saturate( dotResult3_g7 ) ) ) )));
			float3 NormalRock43 = appendResult8_g7;
			float2 uv_TexCoord3 = i.uv_texcoord * _TillingGrass;
			float4 tex2DNode11 = tex2D( _MaskGrassTexture, uv_TexCoord3 );
			float temp_output_1_0_g8 = tex2DNode11.r;
			float temp_output_2_0_g8 = tex2DNode11.b;
			float dotResult3_g8 = dot( temp_output_1_0_g8 , temp_output_2_0_g8 );
			float3 appendResult8_g8 = (float3(temp_output_1_0_g8 , temp_output_2_0_g8 , ( _ScaleNormalGrass * sqrt( ( 1.0 - saturate( dotResult3_g8 ) ) ) )));
			float3 NormalGrass42 = appendResult8_g8;
			float2 uv_SplatMap6 = i.uv_texcoord;
			float4 tex2DNode6 = tex2D( _SplatMap, uv_SplatMap6 );
			float MaskGrass8 = tex2DNode6.g;
			float3 lerpResult118 = lerp( NormalRock43 , NormalGrass42 , MaskGrass8);
			float2 uv_TexCoord61 = i.uv_texcoord * _TillingDirt;
			float4 tex2DNode52 = tex2D( _MaskDirtTexture, uv_TexCoord61 );
			float temp_output_1_0_g9 = tex2DNode52.r;
			float temp_output_2_0_g9 = tex2DNode52.b;
			float dotResult3_g9 = dot( temp_output_1_0_g9 , temp_output_2_0_g9 );
			float3 appendResult8_g9 = (float3(temp_output_1_0_g9 , temp_output_2_0_g9 , ( _ScaleNormalDirt * sqrt( ( 1.0 - saturate( dotResult3_g9 ) ) ) )));
			float3 NormalDirt59 = appendResult8_g9;
			float MaskDirt10 = tex2DNode6.b;
			float3 lerpResult123 = lerp( lerpResult118 , NormalDirt59 , MaskDirt10);
			float2 uv_TexCoord67 = i.uv_texcoord * _TillingGravel;
			float4 tex2DNode65 = tex2D( _MaskGravelTexture, uv_TexCoord67 );
			float temp_output_1_0_g11 = tex2DNode65.r;
			float temp_output_2_0_g11 = tex2DNode65.b;
			float dotResult3_g11 = dot( temp_output_1_0_g11 , temp_output_2_0_g11 );
			float3 appendResult8_g11 = (float3(temp_output_1_0_g11 , temp_output_2_0_g11 , ( _ScaleNormalGravel * sqrt( ( 1.0 - saturate( dotResult3_g11 ) ) ) )));
			float3 NormalGravel77 = appendResult8_g11;
			float MaskGravel9 = tex2DNode6.r;
			float3 lerpResult124 = lerp( lerpResult123 , NormalGravel77 , MaskGravel9);
			float3 FinalNormal125 = lerpResult124;
			float2 uv_TexCoord194 = i.uv_texcoord * _TillingTextureParasite;
			float3 ParasiteTexturePatternNormal197 = UnpackNormal( tex2D( _TextureParasite, uv_TexCoord194 ) );
			float mulTime173 = _Time.y * _SpeedNoiseBorder;
			float simpleNoise162 = SimpleNoise( ( i.uv_texcoord + mulTime173 )*_ScaleBorderNoise );
			float mulTime177 = _Time.y * -_SpeedNoiseBorder;
			float simpleNoise182 = SimpleNoise( ( i.uv_texcoord + mulTime177 + float2( 0.5,0.3 ) )*_ScaleBorderNoise );
			float3 ase_worldPos = i.worldPos;
			float temp_output_5_0_g10 = _RadiusInfection;
			float temp_output_9_0_g10 = ( ( distance( ase_worldPos , _CenterPositionWorld ) - temp_output_5_0_g10 ) / ( temp_output_5_0_g10 - _SideEffect ) );
			float temp_output_142_0 = saturate( temp_output_9_0_g10 );
			float lerpResult164 = lerp( ( simpleNoise162 * simpleNoise182 ) , 1.0 , temp_output_142_0);
			float temp_output_167_0 = ( lerpResult164 * temp_output_142_0 * _BorderIntensity );
			float MaxEffectPosition144 = saturate( temp_output_167_0 );
			float3 lerpResult227 = lerp( FinalNormal125 , ParasiteTexturePatternNormal197 , MaxEffectPosition144);
			float3 FinalNormalContamined224 = ( lerpResult227 * _ContaminedNormalIntensity );
			o.Normal = FinalNormalContamined224;
			float4 AlbedoRock32 = tex2D( _AlbedoRock, uv_TexCoord29 );
			float4 AlbedoGrass5 = tex2D( _AlbedoGrass, uv_TexCoord3 );
			float4 lerpResult18 = lerp( AlbedoRock32 , AlbedoGrass5 , MaskGrass8);
			float4 AlbedoDirt49 = tex2D( _AlbedoDirt, uv_TexCoord61 );
			float4 lerpResult78 = lerp( lerpResult18 , AlbedoDirt49 , MaskDirt10);
			float4 AlbedoGravel70 = tex2D( _AlbedoGravel, uv_TexCoord67 );
			float4 lerpResult81 = lerp( lerpResult78 , AlbedoGravel70 , MaskGravel9);
			float4 FinalAlbedo21 = lerpResult81;
			float2 uv_TexCoord140 = i.uv_texcoord * _TillingTextureParasite;
			float4 ParasiteTexturePatternAlbedo145 = ( tex2D( _TextureParasiteAlbedo, uv_TexCoord140 ) * _AlbedoParasiteIntensity );
			float4 lerpResult155 = lerp( FinalAlbedo21 , ParasiteTexturePatternAlbedo145 , MaxEffectPosition144);
			float4 FinalAlbedoContamined158 = lerpResult155;
			o.Albedo = FinalAlbedoContamined158.rgb;
			float mulTime282 = _Time.y * _Float2;
			float2 panner277 = ( mulTime282 * _Vector4 + i.uv_texcoord);
			float simplePerlin2D278 = snoise( panner277*_NoiseHeightParasiteScale );
			simplePerlin2D278 = simplePerlin2D278*0.5 + 0.5;
			float smoothstepResult285 = smoothstep( 0.42 , 0.9 , simplePerlin2D278);
			float2 uv_TexCoord199 = i.uv_texcoord * _TillingTextureParasite;
			float4 tex2DNode200 = tex2D( _TextureMasks, uv_TexCoord199 );
			float ParasiteTextureMask234 = tex2DNode200.g;
			float FinalHeightParasite272 = ( smoothstepResult285 * ( ParasiteTextureMask234 * MaxEffectPosition144 ) );
			float3 temp_cast_1 = (FinalHeightParasite272).xxx;
			o.Emission = temp_cast_1;
			float SmoothnessRock35 = tex2DNode37.a;
			float SmoothnessGrass16 = tex2DNode11.a;
			float lerpResult101 = lerp( SmoothnessRock35 , SmoothnessGrass16 , MaskGrass8);
			float SmoothnessDirt54 = tex2DNode52.a;
			float lerpResult104 = lerp( lerpResult101 , SmoothnessDirt54 , MaskDirt10);
			float SmoothnessGravel75 = tex2DNode65.a;
			float lerpResult105 = lerp( lerpResult104 , SmoothnessGravel75 , MaskGravel9);
			float FinalSmoothness109 = lerpResult105;
			float ParasiteTextureSmoothness233 = tex2DNode200.r;
			float lerpResult237 = lerp( FinalSmoothness109 , ParasiteTextureSmoothness233 , MaxEffectPosition144);
			float FinalSmoothnessContamined242 = ( lerpResult237 * _ContaminedSmoothnessIntensity );
			o.Smoothness = ( FinalSmoothnessContamined242 * _Smoothness );
			float AmbientOcclusionRock34 = tex2DNode37.g;
			float AmbientOcclusionGrass14 = tex2DNode11.g;
			float lerpResult90 = lerp( AmbientOcclusionRock34 , AmbientOcclusionGrass14 , MaskGrass8);
			float AmbientOcclusionDirt53 = tex2DNode52.g;
			float lerpResult94 = lerp( lerpResult90 , AmbientOcclusionDirt53 , MaskDirt10);
			float AmbientOcclusionGravel73 = tex2DNode65.g;
			float lerpResult95 = lerp( lerpResult94 , AmbientOcclusionGravel73 , MaskGravel9);
			float FinalAmbientOcclusion96 = lerpResult95;
			float4 temp_cast_2 = (FinalAmbientOcclusion96).xxxx;
			float2 uv_TexCoord204 = i.uv_texcoord * _TillingTextureParasite;
			float4 ParasiteTexturePatternAO207 = tex2D( _TextureParasiteAO, uv_TexCoord204 );
			float4 lerpResult215 = lerp( temp_cast_2 , ParasiteTexturePatternAO207 , MaxEffectPosition144);
			float4 FinalAOContamined216 = lerpResult215;
			o.Occlusion = FinalAOContamined216.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
1920;0;1920;1011;407.5397;-7261.261;1.69105;True;False
Node;AmplifyShaderEditor.CommentaryNode;132;-393.3351,3624;Inherit;False;2308.436;1052.4;Alpha Parasite Circle;26;169;168;144;170;167;164;142;162;165;137;138;175;139;163;134;171;173;133;172;177;178;179;181;182;184;183;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;172;7.76059,4077.092;Inherit;False;Property;_SpeedNoiseBorder;SpeedNoiseBorder;28;0;Create;True;0;0;0;False;0;False;1;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1695.964,1113.042;Inherit;False;1129.922;1179.833;Rock;9;29;28;43;27;32;31;30;128;187;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1699.203,-85.60378;Inherit;False;1139.513;1144.976;Grass;9;2;1;24;5;3;4;42;127;188;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1575.603,-676.7692;Inherit;False;975.1481;383.9352;Mask splat map;6;7;6;8;17;10;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;184;146.1228,4376.141;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-1603.462,182.3962;Inherit;False;Property;_TillingGrass;TillingGrass;17;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;24;-1649.203,388.7201;Inherit;False;979.5002;399;Mask ;4;14;16;12;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;28;-1649.223,1380.041;Inherit;False;Property;_TillingRock;TillingRock;18;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;46;-1700.21,2345.333;Inherit;False;1129.922;1179.833;Dirt;9;61;60;59;50;49;48;47;129;186;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-1645.964,1587.365;Inherit;False;979.5002;399;Mask ;4;37;36;35;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-1525.603,-575.1351;Inherit;True;Property;_SplatMap;SplatMap;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;a08ef57615cfe764fb6bc38911e957bc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;62;-1704.715,3556.895;Inherit;False;1129.922;1179.833;Gravel;9;77;70;69;68;67;64;63;130;189;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1489.223,1377.041;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1443.462,179.3962;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;60;-1653.469,2612.333;Inherit;False;Property;_TillingDirt;TillingDirt;19;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;173;360.243,4044.875;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1650.21,2819.657;Inherit;False;979.5002;399;Mask ;4;55;54;53;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;181;389.8244,4560.135;Inherit;False;Constant;_Offset;Offset;31;0;Create;True;0;0;0;False;0;False;0.5,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;177;384.2738,4457.98;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;171;338.4919,3921.17;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1599.203,500.2201;Inherit;True;Property;_MaskGrassTexture;MaskGrassTexture;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;3ff6f87c551189b47ae882fd77943ed9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexCoordVertexDataNode;178;362.5228,4334.276;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1595.964,1698.865;Inherit;True;Property;_MaskRockTexture;MaskRockTexture;14;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;9268c92b6f62b1d4ab278bfcba329876;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;179;607.8562,4350.594;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;163;468.039,4212.824;Inherit;False;Property;_ScaleBorderNoise;ScaleBorderNoise;26;0;Create;True;0;0;0;False;0;False;50;420.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;133;-337.5921,3674;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;175;576.8362,4003.185;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;134;-343.3351,3837.525;Inherit;False;Property;_CenterPositionWorld;CenterPosition;7;0;Create;False;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;55;-1600.21,2931.157;Inherit;True;Property;_MaskDirtTexture;MaskDirtTexture;16;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;7b561dcae4e75b44ba94aa84b224557d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;128;-1650.711,2173.974;Inherit;False;Property;_ScaleNormalRock;ScaleNormalRock;23;0;Create;True;0;0;0;False;0;False;1;0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1356.203,500.2201;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;69;-1657.974,3823.894;Inherit;False;Property;_TillingGravel;TillingGravel;20;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;6;-1270.619,-569.8563;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;-1653.724,935.8429;Inherit;False;Property;_ScaleNormalGrass;ScaleNormalGrass;22;0;Create;True;0;0;0;False;0;False;1;0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;64;-1654.715,4031.218;Inherit;False;979.5002;399;Mask ;4;75;73;71;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-1493.469,2609.333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;37;-1352.964,1698.865;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;182;759.6564,4341.514;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1622.391,3404.888;Inherit;False;Property;_ScaleNormalDirt;ScaleNormalDirt;24;0;Create;True;0;0;0;False;0;False;1;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-1497.974,3820.894;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;162;781.4009,3967.922;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-1784.368,4930.564;Inherit;False;1412.759;433.0004;Parasite Texture Albedo;7;145;256;141;140;136;135;255;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;98;-357.2249,2081.032;Inherit;False;1384.725;613.0347;Smoothness blending;11;109;108;107;106;105;104;103;102;101;100;99;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;137;72.66571,3757.525;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;50.43781,3901.515;Inherit;False;Property;_RadiusInfection;RadiusInfection;8;0;Create;False;0;0;0;False;0;False;0;63.90882;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;43.7919,3984.479;Inherit;False;Property;_SideEffect;SideEffect;5;0;Create;True;0;0;0;False;0;False;0;-4.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1351.379,2923.028;Inherit;True;Property;_TextureSample8;Texture Sample 8;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-828.2784,-555.7682;Inherit;False;MaskGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;187;-1164.086,2067.775;Inherit;False;ReconstructZNormal;-1;;7;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-938.4617,1870.365;Inherit;False;SmoothnessRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;30;-1450.223,1163.041;Inherit;True;Property;_AlbedoRock;AlbedoRock;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;e2743a02d56b8034cad620884cbad28a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;188;-1136.906,867.2;Inherit;False;ReconstructZNormal;-1;;8;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-1604.715,4142.718;Inherit;True;Property;_MaskGravelTexture;MaskGravelTexture;15;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;5ba0118310205464f9b8c2ab072ece29;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1453.462,-35.60377;Inherit;True;Property;_AlbedoGrass;AlbedoGrass;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;4302b9a817cd07e478653a409bfe6000;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-941.7019,671.7199;Inherit;False;SmoothnessGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-942.7089,3102.657;Inherit;False;SmoothnessDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;1090.461,4263.89;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1636.183,4619.258;Inherit;False;Property;_ScaleNormalGravel;ScaleNormalGravel;25;0;Create;True;0;0;0;False;0;False;1;0.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-943.8102,2056.236;Inherit;False;NormalRock;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;165;828.2784,3726.025;Inherit;False;Constant;_Float0;Float 0;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-1361.715,4142.718;Inherit;True;Property;_TextureSample11;Texture Sample 11;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;142;264.6648,3805.525;Inherit;False;Invers_Lerp;-1;;10;65c518da2a8456d4585ebf1c79f44daf;1,11,1;3;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-307.2249,2131.584;Inherit;False;35;SmoothnessRock;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1207.223,1360.041;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-826.2784,-479.7677;Inherit;False;MaskDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;-354.9986,2754.259;Inherit;False;1384.725;613.0347;Normal blending;11;125;124;123;122;121;120;119;118;117;116;115;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-1210.462,161.3962;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-894.5098,834.1891;Inherit;False;NormalGrass;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;47;-1454.469,2395.333;Inherit;True;Property;_AlbedoDirt;AlbedoDirt;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;81f2a88291c6ba44bb27fc92113f6483;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;106;-297.6746,2212.032;Inherit;False;16;SmoothnessGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;186;-1293.554,3265.531;Inherit;False;ReconstructZNormal;-1;;9;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;135;-1757.368,5180.565;Inherit;False;Property;_TillingTextureParasite;TillingTextureParasite;0;0;Create;True;0;0;0;False;0;False;1,1;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;99;-299.6745,2394.032;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-943.7019,517.7201;Inherit;False;AmbientOcclusionGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;189;-1225.448,4507.181;Inherit;False;ReconstructZNormal;-1;;11;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;199;-1786.089,6602.136;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-823.0488,3303.373;Inherit;False;NormalDirt;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;164;1000.803,3764.444;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-863.4617,161.3962;Inherit;False;AlbedoGrass;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;11.2274,2510.173;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-947.2144,4314.218;Inherit;False;SmoothnessGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;1030.408,4071.792;Inherit;False;Property;_BorderIntensity;BorderIntensity;27;0;Create;True;0;0;0;False;0;False;1;1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;201;-2047.834,6739.349;Inherit;True;Property;_TextureMasks;TextureMasks;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;9cbf769917ac556408f9140286468c2f;9cbf769917ac556408f9140286468c2f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-860.2215,1360.041;Inherit;False;AlbedoRock;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;101;-13.67437,2131.032;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-295.4484,2885.259;Inherit;False;42;NormalGrass;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;48;-1211.469,2592.333;Inherit;True;Property;_TextureSample7;Texture Sample 7;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;85;-364.4455,1387.588;Inherit;False;1384.725;613.0347;AO blending;11;96;95;94;93;92;91;90;89;88;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-826.2784,-626.7689;Inherit;False;MaskGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-367.977,677.8135;Inherit;False;1384.725;613.0347;Albedo blending;11;19;39;20;80;18;79;82;83;78;81;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;68;-1458.974,3606.895;Inherit;True;Property;_AlbedoGravel;AlbedoGravel;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;baa9dd568cea8384ab7a41a4751ade93;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-940.4617,1716.365;Inherit;False;AmbientOcclusionRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-304.9987,2804.811;Inherit;False;43;NormalRock;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-53.74738,2395.012;Inherit;False;54;SmoothnessDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-297.4483,3067.259;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;1150.915,3839.004;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-864.4686,2592.333;Inherit;False;AlbedoDirt;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;13.45361,3183.4;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;357.3472,2578.067;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;200;-1490.979,6563.907;Inherit;True;Property;_TextureSample12;Texture Sample 12;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-310.4267,990.8134;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;118;-11.44815,2804.259;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;104;256.1736,2318.473;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-988.5628,4506.088;Inherit;False;NormalGravel;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;63;-1215.974,3803.894;Inherit;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;88;-314.8952,1524.588;Inherit;False;14;AmbientOcclusionGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-314.4455,1438.14;Inherit;False;34;AmbientOcclusionRock;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-944.7089,2948.657;Inherit;False;AmbientOcclusionDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-313.4267,875.8134;Inherit;False;5;AlbedoGrass;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-317.977,728.3656;Inherit;False;32;AlbedoRock;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-306.8952,1700.588;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;272.6972,2477.88;Inherit;False;75;SmoothnessGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-51.52115,3068.239;Inherit;False;59;NormalDirt;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode;209;-1063.708,6454.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;283;205.757,8611.988;Inherit;False;Property;_Float2;Float 2;34;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;577.0011,2365.068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;123;258.4,2991.699;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;196;-1885.436,5983.426;Inherit;True;Property;_TextureParasite;TextureParasite;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;0d1508541d32f0840840edcac1f44747;0d1508541d32f0840840edcac1f44747;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;-1534.369,5172.565;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;194;-1752.39,6251.936;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;4.006741,1816.729;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-951.2144,4161.218;Inherit;False;AmbientOcclusionGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-15.49958,997.7936;Inherit;False;49;AlbedoDirt;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;359.5736,3251.293;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;-20.89503,1437.588;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;136;-1578.369,4975.564;Inherit;True;Property;_TextureParasiteAlbedo;TextureParasiteAlbedo;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;20c81e09508a5ec4fba65a8abee04320;20c81e09508a5ec4fba65a8abee04320;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-868.9741,3803.894;Inherit;False;AlbedoGravel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;274.9236,3151.106;Inherit;False;77;NormalGravel;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;208;-1859.313,5400.247;Inherit;False;1300.938;419.001;Paraiste Texture AO;4;204;205;206;207;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;170;1367.855,3746.035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-60.96806,1701.568;Inherit;False;53;AmbientOcclusionDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-24.4265,727.8135;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;0.4752355,1106.955;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;233;-848.3962,6459.819;Inherit;True;ParasiteTextureSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;245.4217,915.2551;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;350.1266,1884.623;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;281;280.8453,8484.872;Inherit;False;Property;_Vector4;Vector 4;33;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;82;346.5952,1174.848;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;282;338.757,8600.988;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;1526.389,3733.323;Inherit;False;MaxEffectPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;280;275.757,8358.988;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;124;579.2274,3038.295;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;206;-1629.315,5450.247;Inherit;True;Property;_TextureParasiteAO;TextureParasite AO;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;04acbae515bedef47892a8c7b7cf9711;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;243;-221.0506,7070.3;Inherit;False;1188.5;456.9941;Blend Parasite Smoothness;7;239;236;238;237;241;240;242;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1241.348,5293.701;Inherit;False;Property;_AlbedoParasiteIntensity;AlbedoParasiteIntensity;32;0;Create;True;0;0;0;False;0;False;0.37;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;770.5005,2366.666;Inherit;False;FinalSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;204;-1586.315,5647.248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;141;-1213.758,5083.437;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;94;248.953,1625.029;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;335.9452,1081.662;Inherit;False;70;AlbedoGravel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;211;-1101.708,6741.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;265.4766,1784.436;Inherit;False;73;AmbientOcclusionGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;195;-1483.779,6119.808;Inherit;True;Property;_TextureSample9;Texture Sample 9;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;694.757,8723.988;Inherit;False;Property;_NoiseHeightParasiteScale;NoiseHeightParasiteScale;35;0;Create;True;0;0;0;False;0;False;0;3.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;81;566.249,961.8493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-867.3481,5106.701;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;232;-209.1957,6524.593;Inherit;False;1106.026;484.5508;Blend Parasite Normal;7;229;220;228;227;230;224;231;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;277;621.3883,8450.971;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-129.0364,7120.3;Inherit;False;109;FinalSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;205;-1265.704,5558.12;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;239;-133.0364,7333.3;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;-171.0506,7237.229;Inherit;False;233;ParasiteTextureSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;95;569.7806,1671.624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-1184.906,6126.732;Inherit;False;ParasiteTexturePatternNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;772.7267,3039.893;Inherit;False;FinalNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-862.3962,6762.819;Inherit;True;ParasiteTextureMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;278;904.757,8468.988;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-626.4295,5054.043;Inherit;False;ParasiteTexturePatternAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-843.3751,5549.726;Inherit;False;ParasiteTexturePatternAO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;226;-184.6367,5981.729;Inherit;False;1008.168;478.043;Blend  Parasite AO;5;217;218;214;215;216;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;763.28,1673.222;Inherit;False;FinalAmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-82.41317,6574.593;Inherit;False;125;FinalNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;229;-172.1957,6665.891;Inherit;False;197;ParasiteTexturePatternNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;792.7485,952.4474;Inherit;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;-114.1957,6762.891;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;143;-359.4801,5273.504;Inherit;False;1446.504;605.6421;Blend Parasite Albedo;5;147;159;153;155;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;237;226.9636,7247.3;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-245.5886,8082.255;Inherit;True;234;ParasiteTextureMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;-229.7423,8300.461;Inherit;True;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;28.25044,7411.294;Inherit;False;Property;_ContaminedSmoothnessIntensity;Contamined Smoothness Intensity;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;-45.80593,5611.218;Inherit;False;145;ParasiteTexturePatternAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-100.3495,6343.772;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-134.6367,6192.035;Inherit;False;207;ParasiteTexturePatternAO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;454.2504,7314.294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;285;1137.522,8301.724;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.42;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-116.5125,6031.729;Inherit;False;96;FinalAmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;128.4846,5369.568;Inherit;True;21;FinalAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;227;284.8043,6579.891;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;231;7.108994,6893.144;Inherit;False;Property;_ContaminedNormalIntensity;Contamined Normal Intensity;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;161.6166,8140.611;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-46.22351,5723.751;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;155;443.802,5455.751;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;462.5012,6665.903;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;1390.193,8146.646;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;242;664.4493,7281.794;Inherit;False;FinalSmoothnessContamined;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;215;350.7915,6203.364;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;2128.912,7820.82;Inherit;True;FinalHeightParasite;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;224;623.8305,6598.723;Inherit;False;FinalNormalContamined;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;216;571.5317,6266.254;Inherit;False;FinalAOContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;212.9411,286.3007;Inherit;False;Property;_Smoothness;Smoothness;21;0;Create;True;0;0;0;False;0;False;1;0.147;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;177.9035,210.9968;Inherit;False;242;FinalSmoothnessContamined;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;699.4935,5407.063;Inherit;False;FinalAlbedoContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;244;1227.212,7711.924;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;397.2046,0.6100464;Inherit;False;158;FinalAlbedoContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;557.6046,424.3351;Inherit;False;272;FinalHeightParasite;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;207.0346,365.0259;Inherit;False;216;FinalAOContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-1103.131,6556.039;Inherit;True;ParasiteTexturePatternORB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;1547.885,7748.841;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;254;580.6046,515.3351;Inherit;False;Property;_Tesselation;Tesselation;31;0;Create;True;0;0;0;False;0;False;0;0;0;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;210;-1243.708,6879.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-27.0723,41.18179;Inherit;False;224;FinalNormalContamined;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;168;1336.187,3889.185;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;498.9411,218.3007;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;273;1258.888,7927.361;Inherit;False;Constant;_Vector3;Vector 3;40;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-824.4565,-408.8326;Inherit;False;RockMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;287;1863.855,7705.749;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;-977.3962,6991.819;Inherit;True;ParasiteTextureHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;886,130;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/TerrainShader_02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;251;-216.1534,7538.997;Inherit;False;1188.5;456.9941;BlendParasiteHeight;0;;1,1,1,1;0;0
WireConnection;184;0;172;0
WireConnection;29;0;28;0
WireConnection;3;0;4;0
WireConnection;173;0;172;0
WireConnection;177;0;184;0
WireConnection;179;0;178;0
WireConnection;179;1;177;0
WireConnection;179;2;181;0
WireConnection;175;0;171;0
WireConnection;175;1;173;0
WireConnection;11;0;12;0
WireConnection;11;1;3;0
WireConnection;6;0;7;0
WireConnection;61;0;60;0
WireConnection;37;0;36;0
WireConnection;37;1;29;0
WireConnection;182;0;179;0
WireConnection;182;1;163;0
WireConnection;67;0;69;0
WireConnection;162;0;175;0
WireConnection;162;1;163;0
WireConnection;137;0;133;0
WireConnection;137;1;134;0
WireConnection;52;0;55;0
WireConnection;52;1;61;0
WireConnection;8;0;6;2
WireConnection;187;9;128;0
WireConnection;187;1;37;1
WireConnection;187;2;37;3
WireConnection;35;0;37;4
WireConnection;188;9;127;0
WireConnection;188;1;11;1
WireConnection;188;2;11;3
WireConnection;16;0;11;4
WireConnection;54;0;52;4
WireConnection;183;0;162;0
WireConnection;183;1;182;0
WireConnection;43;0;187;0
WireConnection;65;0;71;0
WireConnection;65;1;67;0
WireConnection;142;4;137;0
WireConnection;142;5;138;0
WireConnection;142;6;139;0
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;10;0;6;3
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;42;0;188;0
WireConnection;186;9;129;0
WireConnection;186;1;52;1
WireConnection;186;2;52;3
WireConnection;14;0;11;2
WireConnection;189;9;130;0
WireConnection;189;1;65;1
WireConnection;189;2;65;3
WireConnection;199;0;135;0
WireConnection;59;0;186;0
WireConnection;164;0;183;0
WireConnection;164;1;165;0
WireConnection;164;2;142;0
WireConnection;5;0;2;0
WireConnection;75;0;65;4
WireConnection;32;0;31;0
WireConnection;101;0;100;0
WireConnection;101;1;106;0
WireConnection;101;2;99;0
WireConnection;48;0;47;0
WireConnection;48;1;61;0
WireConnection;9;0;6;1
WireConnection;34;0;37;2
WireConnection;167;0;164;0
WireConnection;167;1;142;0
WireConnection;167;2;169;0
WireConnection;49;0;48;0
WireConnection;200;0;201;0
WireConnection;200;1;199;0
WireConnection;118;0;116;0
WireConnection;118;1;115;0
WireConnection;118;2;117;0
WireConnection;104;0;101;0
WireConnection;104;1;107;0
WireConnection;104;2;102;0
WireConnection;77;0;189;0
WireConnection;63;0;68;0
WireConnection;63;1;67;0
WireConnection;53;0;52;2
WireConnection;209;0;200;1
WireConnection;105;0;104;0
WireConnection;105;1;108;0
WireConnection;105;2;103;0
WireConnection;123;0;118;0
WireConnection;123;1;120;0
WireConnection;123;2;119;0
WireConnection;140;0;135;0
WireConnection;194;0;135;0
WireConnection;73;0;65;2
WireConnection;90;0;87;0
WireConnection;90;1;88;0
WireConnection;90;2;86;0
WireConnection;70;0;63;0
WireConnection;170;0;167;0
WireConnection;18;0;39;0
WireConnection;18;1;20;0
WireConnection;18;2;19;0
WireConnection;233;0;209;0
WireConnection;78;0;18;0
WireConnection;78;1;80;0
WireConnection;78;2;79;0
WireConnection;282;0;283;0
WireConnection;144;0;170;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;124;2;121;0
WireConnection;109;0;105;0
WireConnection;204;0;135;0
WireConnection;141;0;136;0
WireConnection;141;1;140;0
WireConnection;94;0;90;0
WireConnection;94;1;89;0
WireConnection;94;2;91;0
WireConnection;211;0;200;2
WireConnection;195;0;196;0
WireConnection;195;1;194;0
WireConnection;81;0;78;0
WireConnection;81;1;83;0
WireConnection;81;2;82;0
WireConnection;255;0;141;0
WireConnection;255;1;256;0
WireConnection;277;0;280;0
WireConnection;277;2;281;0
WireConnection;277;1;282;0
WireConnection;205;0;206;0
WireConnection;205;1;204;0
WireConnection;95;0;94;0
WireConnection;95;1;93;0
WireConnection;95;2;92;0
WireConnection;197;0;195;0
WireConnection;125;0;124;0
WireConnection;234;0;211;0
WireConnection;278;0;277;0
WireConnection;278;1;279;0
WireConnection;145;0;255;0
WireConnection;207;0;205;0
WireConnection;96;0;95;0
WireConnection;21;0;81;0
WireConnection;237;0;238;0
WireConnection;237;1;236;0
WireConnection;237;2;239;0
WireConnection;240;0;237;0
WireConnection;240;1;241;0
WireConnection;285;0;278;0
WireConnection;227;0;220;0
WireConnection;227;1;229;0
WireConnection;227;2;228;0
WireConnection;275;0;274;0
WireConnection;275;1;276;0
WireConnection;155;0;153;0
WireConnection;155;1;159;0
WireConnection;155;2;147;0
WireConnection;230;0;227;0
WireConnection;230;1;231;0
WireConnection;284;0;285;0
WireConnection;284;1;275;0
WireConnection;242;0;240;0
WireConnection;215;0;214;0
WireConnection;215;1;218;0
WireConnection;215;2;217;0
WireConnection;272;0;284;0
WireConnection;224;0;230;0
WireConnection;216;0;215;0
WireConnection;158;0;155;0
WireConnection;202;0;200;0
WireConnection;249;1;244;0
WireConnection;249;2;273;0
WireConnection;210;0;200;3
WireConnection;168;0;167;0
WireConnection;168;1;169;0
WireConnection;112;0;110;0
WireConnection;112;1;113;0
WireConnection;17;0;6;4
WireConnection;287;0;249;0
WireConnection;235;0;210;0
WireConnection;0;0;22;0
WireConnection;0;1;126;0
WireConnection;0;2;253;0
WireConnection;0;4;112;0
WireConnection;0;5;97;0
WireConnection;0;14;254;0
ASEEND*/
//CHKSM=929522A89DDA3DB22ACB3D0876AA128B9AC16A76