// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/TerrainShader_02"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_TillingTextureParasite("TillingTextureParasite", Vector) = (1,1,0,0)
		[NoScaleOffset]_TextureParasiteAO("TextureParasite AO", 2D) = "white" {}
		[NoScaleOffset]_TextureMasks("TextureMasks", 2D) = "white" {}
		[NoScaleOffset]_TextureParasite("TextureParasite", 2D) = "bump" {}
		[NoScaleOffset]_TextureParasiteAlbedo("TextureParasiteAlbedo", 2D) = "white" {}
		_SideEffect("SideEffect", Float) = 0
		[NoScaleOffset]_AlbedoGrass("AlbedoGrass", 2D) = "white" {}
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
		_ContaminedNormalIntensity("Contamined Normal Intensity", Float) = 1
		_ContaminedSmoothnessIntensity("Contamined Smoothness Intensity", Float) = 0
		_AlbedoParasiteIntensity("AlbedoParasiteIntensity", Float) = 0.37
		_Float1("Float 1", Float) = 0
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_VectoryDirection("Vectory Direction", Vector) = (5.3,10,0,0)
		_Speed("Speed", Float) = 0.001
		_NoiseHeightParasiteScale("NoiseHeightParasiteScale", Float) = 174.73
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
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Speed;
		uniform float2 _VectoryDirection;
		uniform float _NoiseHeightParasiteScale;
		uniform sampler2D _TextureMasks;
		uniform float2 _TillingTextureParasite;
		uniform float _SpeedNoiseBorder;
		uniform float _ScaleBorderNoise;
		uniform float3 CenterPosition;
		uniform float RadiusInfection;
		uniform float _SideEffect;
		uniform float _BorderIntensity;
		uniform float _Float1;
		uniform sampler2D _MaskRockTexture;
		uniform float2 _TillingRock;
		uniform sampler2D _MaskGrassTexture;
		uniform float2 _TillingGrass;
		uniform sampler2D _SplatMap;
		uniform sampler2D _MaskDirtTexture;
		uniform float2 _TillingDirt;
		uniform sampler2D _MaskGravelTexture;
		uniform float2 _TillingGravel;
		uniform sampler2D _TextureParasite;
		uniform float _ContaminedNormalIntensity;
		uniform sampler2D _AlbedoRock;
		uniform sampler2D _AlbedoGrass;
		uniform sampler2D _AlbedoDirt;
		uniform sampler2D _AlbedoGravel;
		uniform sampler2D _TextureParasiteAlbedo;
		uniform float _AlbedoParasiteIntensity;
		uniform float4 _EmissionColor;
		uniform float _ContaminedSmoothnessIntensity;
		uniform float _Smoothness;
		uniform sampler2D _TextureParasiteAO;
		uniform float _EdgeLength;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime282 = _Time.y * _Speed;
			float2 panner277 = ( mulTime282 * _VectoryDirection + v.texcoord.xy);
			float simplePerlin2D278 = snoise( panner277*_NoiseHeightParasiteScale );
			simplePerlin2D278 = simplePerlin2D278*0.5 + 0.5;
			float smoothstepResult285 = smoothstep( 0.42 , 3.21 , simplePerlin2D278);
			float2 uv_TexCoord199 = v.texcoord.xy * _TillingTextureParasite;
			float4 tex2DNode200 = tex2Dlod( _TextureMasks, float4( uv_TexCoord199, 0, 0.0) );
			float ParasiteTextureMask234 = tex2DNode200.g;
			float mulTime173 = _Time.y * _SpeedNoiseBorder;
			float simpleNoise162 = SimpleNoise( ( v.texcoord.xy + mulTime173 )*_ScaleBorderNoise );
			float mulTime177 = _Time.y * -_SpeedNoiseBorder;
			float simpleNoise182 = SimpleNoise( ( v.texcoord.xy + mulTime177 + float2( 0.5,0.3 ) )*_ScaleBorderNoise );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_5_0_g17 = RadiusInfection;
			float temp_output_9_0_g17 = ( ( distance( ase_worldPos , CenterPosition ) - temp_output_5_0_g17 ) / ( temp_output_5_0_g17 - _SideEffect ) );
			float temp_output_142_0 = saturate( temp_output_9_0_g17 );
			float lerpResult164 = lerp( ( simpleNoise162 * simpleNoise182 ) , 1.0 , temp_output_142_0);
			float temp_output_167_0 = ( lerpResult164 * temp_output_142_0 * _BorderIntensity );
			float MaxEffectPosition144 = saturate( temp_output_167_0 );
			float FinalHeightParasite272 = ( smoothstepResult285 * ( ParasiteTextureMask234 * MaxEffectPosition144 ) );
			float3 temp_cast_0 = (( FinalHeightParasite272 * _Float1 )).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord29 = i.uv_texcoord * _TillingRock;
			float4 tex2DNode37 = tex2D( _MaskRockTexture, uv_TexCoord29 );
			float3 appendResult8_g19 = (float3(( ( tex2DNode37.r * 2.0 ) - 1.0 ) , ( ( tex2DNode37.b * 2.0 ) - 1.0 ) , 0.707));
			float3 NormalRock43 = appendResult8_g19;
			float2 uv_TexCoord3 = i.uv_texcoord * _TillingGrass;
			float4 tex2DNode11 = tex2D( _MaskGrassTexture, uv_TexCoord3 );
			float3 appendResult8_g18 = (float3(( ( tex2DNode11.r * 2.0 ) - 1.0 ) , ( ( tex2DNode11.b * 2.0 ) - 1.0 ) , 0.707));
			float3 NormalGrass42 = appendResult8_g18;
			float2 uv_SplatMap6 = i.uv_texcoord;
			float4 tex2DNode6 = tex2D( _SplatMap, uv_SplatMap6 );
			float MaskGrass8 = tex2DNode6.g;
			float3 lerpResult118 = lerp( NormalRock43 , NormalGrass42 , MaskGrass8);
			float2 uv_TexCoord61 = i.uv_texcoord * _TillingDirt;
			float4 tex2DNode52 = tex2D( _MaskDirtTexture, uv_TexCoord61 );
			float3 appendResult8_g20 = (float3(( ( tex2DNode52.r * 2.0 ) - 1.0 ) , ( ( tex2DNode52.b * 2.0 ) - 1.0 ) , 0.707));
			float3 NormalDirt59 = appendResult8_g20;
			float MaskDirt10 = tex2DNode6.b;
			float3 lerpResult123 = lerp( lerpResult118 , NormalDirt59 , MaskDirt10);
			float2 uv_TexCoord67 = i.uv_texcoord * _TillingGravel;
			float4 tex2DNode65 = tex2D( _MaskGravelTexture, uv_TexCoord67 );
			float3 appendResult8_g21 = (float3(( ( tex2DNode65.r * 2.0 ) - 1.0 ) , ( ( tex2DNode65.b * 2.0 ) - 1.0 ) , 0.707));
			float3 NormalGravel77 = appendResult8_g21;
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
			float temp_output_5_0_g17 = RadiusInfection;
			float temp_output_9_0_g17 = ( ( distance( ase_worldPos , CenterPosition ) - temp_output_5_0_g17 ) / ( temp_output_5_0_g17 - _SideEffect ) );
			float temp_output_142_0 = saturate( temp_output_9_0_g17 );
			float lerpResult164 = lerp( ( simpleNoise162 * simpleNoise182 ) , 1.0 , temp_output_142_0);
			float temp_output_167_0 = ( lerpResult164 * temp_output_142_0 * _BorderIntensity );
			float MaxEffectPosition144 = saturate( temp_output_167_0 );
			float3 lerpResult227 = lerp( FinalNormal125 , ( ParasiteTexturePatternNormal197 * _ContaminedNormalIntensity ) , MaxEffectPosition144);
			float3 FinalNormalContamined224 = lerpResult227;
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
			float mulTime282 = _Time.y * _Speed;
			float2 panner277 = ( mulTime282 * _VectoryDirection + i.uv_texcoord);
			float simplePerlin2D278 = snoise( panner277*_NoiseHeightParasiteScale );
			simplePerlin2D278 = simplePerlin2D278*0.5 + 0.5;
			float smoothstepResult285 = smoothstep( 0.42 , 3.21 , simplePerlin2D278);
			float2 uv_TexCoord199 = i.uv_texcoord * _TillingTextureParasite;
			float4 tex2DNode200 = tex2D( _TextureMasks, uv_TexCoord199 );
			float ParasiteTextureMask234 = tex2DNode200.g;
			float FinalHeightParasite272 = ( smoothstepResult285 * ( ParasiteTextureMask234 * MaxEffectPosition144 ) );
			o.Emission = ( FinalHeightParasite272 * _EmissionColor ).rgb;
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
392;73;1535;809;877.9803;-3449.037;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;132;-393.3351,3624;Inherit;False;2308.436;1052.4;Alpha Parasite Circle;26;169;168;144;170;167;164;142;162;165;137;138;175;139;163;134;171;173;133;172;177;178;179;181;182;184;183;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1695.964,1113.042;Inherit;False;1129.922;1179.833;Rock;9;29;28;43;27;32;31;30;128;304;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1699.203,-85.60378;Inherit;False;1139.513;1144.976;Grass;11;2;1;24;5;3;4;42;127;308;309;305;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;172;7.76059,4077.092;Inherit;False;Property;_SpeedNoiseBorder;SpeedNoiseBorder;31;0;Create;True;0;0;0;False;0;False;1;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1700.21,2345.333;Inherit;False;1129.922;1179.833;Dirt;10;61;60;59;50;49;48;47;129;297;300;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;4;-1603.462,182.3962;Inherit;False;Property;_TillingGrass;TillingGrass;20;0;Create;True;0;0;0;False;0;False;1,1;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;28;-1649.223,1380.041;Inherit;False;Property;_TillingRock;TillingRock;21;0;Create;True;0;0;0;False;0;False;1,1;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;184;146.1228,4376.141;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1575.603,-676.7692;Inherit;False;975.1481;383.9352;Mask splat map;6;7;6;8;17;10;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;60;-1653.469,2612.333;Inherit;False;Property;_TillingDirt;TillingDirt;22;0;Create;True;0;0;0;False;0;False;1,1;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;36;-2113.964,1716.865;Inherit;True;Property;_MaskRockTexture;MaskRockTexture;17;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;a9c5af41b5418b04e90415d2225615bf;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;12;-2015.203,532.2201;Inherit;True;Property;_MaskGrassTexture;MaskGrassTexture;16;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;4e4c0f35c0b616c4e82b950f411955a0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1443.462,179.3962;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1489.223,1377.041;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;27;-1645.964,1587.365;Inherit;False;979.5002;399;Mask ;6;37;35;34;301;302;303;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1649.203,388.7201;Inherit;False;979.5002;399;Mask ;5;14;16;11;306;307;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;62;-1859.715,3556.895;Inherit;False;1284.922;1236.833;Gravel;11;70;63;68;130;67;64;69;292;294;295;296;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-1525.603,-575.1351;Inherit;True;Property;_SplatMap;SplatMap;15;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;a08ef57615cfe764fb6bc38911e957bc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;11;-1772.203,532.2201;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;55;-1933.21,2881.157;Inherit;True;Property;_MaskDirtTexture;MaskDirtTexture;19;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;8dd00ba2548eeb344ae22b2c056cb2cd;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexCoordVertexDataNode;171;338.4919,3921.17;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;69;-1657.974,3823.894;Inherit;False;Property;_TillingGravel;TillingGravel;23;0;Create;True;0;0;0;False;0;False;1,1;20,20;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;50;-1650.21,2819.657;Inherit;False;979.5002;399;Mask ;5;54;53;52;298;299;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;177;384.2738,4457.98;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-1870.964,1716.865;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;64;-1833.715,3994.218;Inherit;False;1308.5;372;Mask ;4;65;71;73;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;178;362.5228,4334.276;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;181;389.8244,4560.135;Inherit;False;Constant;_Offset;Offset;31;0;Create;True;0;0;0;False;0;False;0.5,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-1493.469,2609.333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;173;360.243,4044.875;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;134;-343.3351,3837.525;Inherit;False;Global;CenterPosition;CenterPosition;13;0;Create;False;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;133;-337.5921,3674;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-1421.672,550.582;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-1436.172,817.082;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1684.379,2873.028;Inherit;True;Property;_TextureSample8;Texture Sample 8;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;-1543.908,1760.855;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1270.619,-569.8563;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-1559.408,1882.355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-1497.974,3820.894;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;179;607.8562,4350.594;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-1804.715,4047.718;Inherit;True;Property;_MaskGravelTexture;MaskGravelTexture;18;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;42ea80984835b9946be53ba827907ba0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;163;468.039,4212.824;Inherit;False;Property;_ScaleBorderNoise;ScaleBorderNoise;29;0;Create;True;0;0;0;False;0;False;50;420.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;175;576.8362,4003.185;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;98;-357.2249,2081.032;Inherit;False;1384.725;613.0347;Smoothness blending;11;109;108;107;106;105;104;103;102;101;100;99;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;30;-1450.223,1163.041;Inherit;True;Property;_AlbedoRock;AlbedoRock;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;e2743a02d56b8034cad620884cbad28a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-1336.058,3016.662;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;307;-1181.672,552.582;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-938.4617,1870.365;Inherit;False;SmoothnessRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-941.7019,671.7199;Inherit;False;SmoothnessGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-1784.368,4930.564;Inherit;False;1412.759;433.0004;Parasite Texture Albedo;7;145;256;141;140;136;135;255;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1453.462,-35.60377;Inherit;True;Property;_AlbedoGrass;AlbedoGrass;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;4302b9a817cd07e478653a409bfe6000;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;138;14.93492,3879.031;Inherit;False;Global;RadiusInfection;RadiusInfection;13;0;Create;False;0;0;0;False;0;False;0;42.99944;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-828.2784,-555.7682;Inherit;False;MaskGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;43.7919,3984.479;Inherit;False;Property;_SideEffect;SideEffect;10;0;Create;True;0;0;0;False;0;False;0;-4.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-1561.715,4047.718;Inherit;True;Property;_TextureSample11;Texture Sample 11;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;137;72.66571,3757.525;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;162;781.4009,3967.922;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;308;-1283.172,818.082;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;182;759.6564,4341.514;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;304;-1390.408,1917.355;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;303;-1374.908,1794.855;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;-1351.558,3138.162;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-307.2249,2131.584;Inherit;False;35;SmoothnessRock;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1207.223,1360.041;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;99;-299.6745,2394.032;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;310;-1164.086,2067.775;Inherit;False;ReconstructZNormal;-1;;19;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;165;828.2784,3726.025;Inherit;False;Constant;_Float0;Float 0;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;1090.461,4263.89;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;47;-1454.469,2395.333;Inherit;True;Property;_AlbedoDirt;AlbedoDirt;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;81f2a88291c6ba44bb27fc92113f6483;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;309;-1098.906,827.2;Inherit;False;ReconstructZNormal;-1;;18;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;142;264.6648,3805.525;Inherit;False;Invers_Lerp;-1;;17;65c518da2a8456d4585ebf1c79f44daf;1,11,1;3;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-297.6746,2212.032;Inherit;False;16;SmoothnessGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;299;-1167.058,3050.662;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-942.7089,3102.657;Inherit;False;SmoothnessDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-1368.406,4374.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1210.462,161.3962;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-1383.906,4496.286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;135;-1757.368,5180.565;Inherit;False;Property;_TillingTextureParasite;TillingTextureParasite;5;0;Create;True;0;0;0;False;0;False;1,1;16,16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;300;-1182.558,3173.162;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-826.2784,-479.7677;Inherit;False;MaskDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;201;-2047.834,6739.349;Inherit;True;Property;_TextureMasks;TextureMasks;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;9cbf769917ac556408f9140286468c2f;9cbf769917ac556408f9140286468c2f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-797.5098,811.1891;Inherit;True;NormalGrass;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;68;-1458.974,3606.895;Inherit;True;Property;_AlbedoGravel;AlbedoGravel;14;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;baa9dd568cea8384ab7a41a4751ade93;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;101;-13.67437,2131.032;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;311;-1293.554,3265.531;Inherit;False;ReconstructZNormal;-1;;20;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;251;-375.7311,7576.833;Inherit;False;1971.583;1154.53;BlendParasiteHeight;13;275;274;276;272;284;285;278;279;277;281;280;282;283;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;114;-354.9986,2754.259;Inherit;False;1384.725;613.0347;Normal blending;10;125;124;123;122;121;120;119;118;117;115;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-1126.214,4277.218;Inherit;False;SmoothnessGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-53.74738,2395.012;Inherit;False;54;SmoothnessDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-860.2215,1360.041;Inherit;False;AlbedoRock;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-940.4617,1716.365;Inherit;False;AmbientOcclusionRock;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-364.4455,1387.588;Inherit;False;1384.725;613.0347;AO blending;11;96;95;94;93;92;91;90;89;88;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;48;-1211.469,2592.333;Inherit;True;Property;_TextureSample7;Texture Sample 7;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-863.4617,161.3962;Inherit;False;AlbedoGrass;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;164;1000.803,3764.444;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;199;-1786.089,6602.136;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-943.7019,517.7201;Inherit;False;AmbientOcclusionGrass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-943.8102,2056.236;Inherit;False;NormalRock;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;169;1030.408,4071.792;Inherit;False;Property;_BorderIntensity;BorderIntensity;30;0;Create;True;0;0;0;False;0;False;1;2.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;294;-1199.406,4408.786;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-826.2784,-626.7689;Inherit;False;MaskGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;11.2274,2510.173;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;296;-1214.906,4531.286;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-367.977,677.8135;Inherit;False;1384.725;613.0347;Albedo blending;11;19;39;20;80;18;79;82;83;78;81;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-337.5682,1503.427;Inherit;False;34;AmbientOcclusionRock;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-823.0488,3303.373;Inherit;False;NormalDirt;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-313.4267,875.8134;Inherit;False;5;AlbedoGrass;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-287.4484,2951.259;Inherit;False;42;NormalGrass;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-537.9987,2807.811;Inherit;True;43;NormalRock;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;312;-1072.448,4513.181;Inherit;False;ReconstructZNormal;-1;;21;aafcf35eb3822c44a913771e0059d491;0;3;9;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-335.8952,1797.588;Inherit;True;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-317.977,728.3656;Inherit;False;32;AlbedoRock;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-354.8952,1595.588;Inherit;False;14;AmbientOcclusionGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-297.4483,3067.259;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;272.6972,2477.88;Inherit;False;75;SmoothnessGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-310.4267,990.8134;Inherit;False;8;MaskGrass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;200;-1490.979,6563.907;Inherit;True;Property;_TextureSample12;Texture Sample 12;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-1215.974,3803.894;Inherit;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-864.4686,2592.333;Inherit;False;AlbedoDirt;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-285.4921,8373.799;Inherit;False;Property;_Speed;Speed;39;0;Create;True;0;0;0;False;0;False;0.001;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;357.3472,2578.067;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-944.7089,2948.657;Inherit;False;AmbientOcclusionDirt;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;256.1736,2318.473;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;1150.915,3839.004;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;280;-214.4921,8120.8;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;80;-15.49958,997.7936;Inherit;False;49;AlbedoDirt;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;282;-111.4922,8373.799;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;211;-1101.708,6741.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-68.96806,1620.568;Inherit;False;53;AmbientOcclusionDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;194;-1752.39,6251.936;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;120;-51.52115,3068.239;Inherit;False;59;NormalDirt;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;208;-1859.313,5400.247;Inherit;False;1300.938;419.001;Paraiste Texture AO;4;204;205;206;207;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;118;-11.44815,2804.259;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;-1534.369,5172.565;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;79;0.4752355,1106.955;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-741.5628,4508.088;Inherit;False;NormalGravel;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;196;-1885.436,5983.426;Inherit;True;Property;_TextureParasite;TextureParasite;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;0d1508541d32f0840840edcac1f44747;0d1508541d32f0840840edcac1f44747;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;281;-209.4039,8246.683;Inherit;False;Property;_VectoryDirection;Vectory Direction;38;0;Create;True;0;0;0;False;0;False;5.3,10;5.3,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;119;13.45361,3183.4;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;136;-1578.369,4975.564;Inherit;True;Property;_TextureParasiteAlbedo;TextureParasiteAlbedo;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;20c81e09508a5ec4fba65a8abee04320;20c81e09508a5ec4fba65a8abee04320;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;18;-24.4265,727.8135;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;105;577.0011,2365.068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;170;1367.855,3746.035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;209;-1063.708,6454.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-868.9741,3803.894;Inherit;False;AlbedoGravel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-20.89503,1437.588;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1130.214,4124.218;Inherit;False;AmbientOcclusionGravel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;4.006741,1816.729;Inherit;False;10;MaskDirt;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;274.9236,3151.106;Inherit;False;77;NormalGravel;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;335.9452,1081.662;Inherit;False;70;AlbedoGravel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-862.3962,6762.819;Inherit;True;ParasiteTextureMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1241.348,5293.701;Inherit;False;Property;_AlbedoParasiteIntensity;AlbedoParasiteIntensity;35;0;Create;True;0;0;0;False;0;False;0.37;0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;265.4766,1784.436;Inherit;False;73;AmbientOcclusionGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;359.5736,3251.293;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;195;-1483.779,6119.808;Inherit;True;Property;_TextureSample9;Texture Sample 9;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;243;-221.0506,7070.3;Inherit;False;1188.5;456.9941;Blend Parasite Smoothness;7;239;236;238;237;241;240;242;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;123;253.4,2883.699;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;1526.389,3733.323;Inherit;False;MaxEffectPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;141;-1213.758,5083.437;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;112.5079,8513.8;Inherit;False;Property;_NoiseHeightParasiteScale;NoiseHeightParasiteScale;40;0;Create;True;0;0;0;False;0;False;174.73;174.73;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;206;-1629.315,5450.247;Inherit;True;Property;_TextureParasiteAO;TextureParasite AO;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;04acbae515bedef47892a8c7b7cf9711;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;233;-848.3962,6459.819;Inherit;True;ParasiteTextureSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;350.1266,1884.623;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;277;131.1391,8212.781;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;346.5952,1174.848;Inherit;False;9;MaskGravel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;204;-1586.315,5647.248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;78;245.4217,915.2551;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;94;248.953,1625.029;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;770.5005,2366.666;Inherit;False;FinalSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;156.1077,7803.101;Inherit;True;234;ParasiteTextureMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-867.3481,5106.701;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;124;579.2274,3038.295;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-1184.906,6126.732;Inherit;False;ParasiteTexturePatternNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;331.5318,7983.472;Inherit;True;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;232;-209.1957,6524.593;Inherit;False;1106.026;484.5508;Blend Parasite Normal;7;229;220;228;227;230;224;231;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;95;569.7806,1671.624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-129.0364,7120.3;Inherit;False;109;FinalSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;81;566.249,961.8493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;205;-1265.704,5558.12;Inherit;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;278;426.508,8247.799;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;-171.0506,7237.229;Inherit;False;233;ParasiteTextureSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;239;-133.0364,7333.3;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;237;226.9636,7247.3;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-626.4295,5054.043;Inherit;False;ParasiteTexturePatternAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;808.7267,3029.893;Inherit;True;FinalNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;229;-172.1957,6665.891;Inherit;False;197;ParasiteTexturePatternNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-843.3751,5549.726;Inherit;False;ParasiteTexturePatternAO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;226;-184.6367,5981.729;Inherit;False;1008.168;478.043;Blend  Parasite AO;5;217;218;214;215;216;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;792.7485,952.4474;Inherit;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;241;28.25044,7411.294;Inherit;False;Property;_ContaminedSmoothnessIntensity;Contamined Smoothness Intensity;33;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;285;731.2729,8111.535;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.42;False;2;FLOAT;3.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-144.891,6903.144;Inherit;False;Property;_ContaminedNormalIntensity;Contamined Normal Intensity;32;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;722.8914,7823.621;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;763.28,1673.222;Inherit;False;FinalAmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;143;-132.5753,5089.821;Inherit;False;1446.504;605.6421;Blend Parasite Albedo;5;147;159;153;155;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;181.0989,5427.535;Inherit;False;145;ParasiteTexturePatternAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-116.5125,6031.729;Inherit;False;96;FinalAmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;1035.944,7942.458;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;355.3895,5185.885;Inherit;True;21;FinalAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;169.5012,6740.903;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;180.6813,5540.068;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;454.2504,7314.294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-82.41317,6574.593;Inherit;False;125;FinalNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-100.3495,6343.772;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;-114.1957,6762.891;Inherit;False;144;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-134.6367,6192.035;Inherit;False;207;ParasiteTexturePatternAO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;215;350.7915,6203.364;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;155;670.7067,5272.068;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;1278.165,7935.667;Inherit;True;FinalHeightParasite;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;242;664.4493,7281.794;Inherit;False;FinalSmoothnessContamined;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;227;284.8043,6579.891;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-235.0965,326.9968;Inherit;False;242;FinalSmoothnessContamined;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;291;-260.0012,80.7724;Inherit;False;Property;_EmissionColor;EmissionColor;37;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9150943,0.06474714,0.06474714,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;224;623.8305,6598.723;Inherit;False;FinalNormalContamined;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;289;500.5449,460.7428;Inherit;False;Property;_Float1;Float 1;36;0;Create;True;0;0;0;False;0;False;0;2E-05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-113.0589,417.3007;Inherit;False;Property;_Smoothness;Smoothness;24;0;Create;True;0;0;0;False;0;False;1;0.169;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;216;571.5317,6266.254;Inherit;False;FinalAOContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;199.6046,187.3351;Inherit;False;272;FinalHeightParasite;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;926.3983,5223.38;Inherit;False;FinalAlbedoContamined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;757.5449,414.7428;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;453.9988,214.7724;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1653.724,935.8429;Inherit;False;Property;_ScaleNormalGrass;ScaleNormalGrass;25;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;29.03461,539.0259;Inherit;False;216;FinalAOContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1622.391,3404.888;Inherit;False;Property;_ScaleNormalDirt;ScaleNormalDirt;27;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1636.183,4619.258;Inherit;False;Property;_ScaleNormalGravel;ScaleNormalGravel;28;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;172.9411,349.3007;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-1103.131,6556.039;Inherit;True;ParasiteTexturePatternORB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;-977.3962,6991.819;Inherit;True;ParasiteTextureHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;397.2046,0.6100464;Inherit;False;158;FinalAlbedoContamined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1650.711,2173.974;Inherit;False;Property;_ScaleNormalRock;ScaleNormalRock;26;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;210;-1243.708,6879.518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-27.0723,41.18179;Inherit;False;224;FinalNormalContamined;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-824.4565,-408.8326;Inherit;False;RockMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;580.6046,515.3351;Inherit;False;Property;_Tesselation;Tesselation;34;0;Create;True;0;0;0;False;0;False;0;0;0;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;168;1336.187,3889.185;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;886,130;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/TerrainShader_02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;184;0;172;0
WireConnection;3;0;4;0
WireConnection;29;0;28;0
WireConnection;11;0;12;0
WireConnection;11;1;3;0
WireConnection;177;0;184;0
WireConnection;37;0;36;0
WireConnection;37;1;29;0
WireConnection;61;0;60;0
WireConnection;173;0;172;0
WireConnection;306;0;11;1
WireConnection;305;0;11;3
WireConnection;52;0;55;0
WireConnection;52;1;61;0
WireConnection;302;0;37;1
WireConnection;6;0;7;0
WireConnection;301;0;37;3
WireConnection;67;0;69;0
WireConnection;179;0;178;0
WireConnection;179;1;177;0
WireConnection;179;2;181;0
WireConnection;175;0;171;0
WireConnection;175;1;173;0
WireConnection;298;0;52;1
WireConnection;307;0;306;0
WireConnection;35;0;37;4
WireConnection;16;0;11;4
WireConnection;8;0;6;2
WireConnection;65;0;71;0
WireConnection;65;1;67;0
WireConnection;137;0;133;0
WireConnection;137;1;134;0
WireConnection;162;0;175;0
WireConnection;162;1;163;0
WireConnection;308;0;305;0
WireConnection;182;0;179;0
WireConnection;182;1;163;0
WireConnection;304;0;301;0
WireConnection;303;0;302;0
WireConnection;297;0;52;3
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;310;1;303;0
WireConnection;310;2;304;0
WireConnection;183;0;162;0
WireConnection;183;1;182;0
WireConnection;309;1;307;0
WireConnection;309;2;308;0
WireConnection;142;4;137;0
WireConnection;142;5;138;0
WireConnection;142;6;139;0
WireConnection;299;0;298;0
WireConnection;54;0;52;4
WireConnection;292;0;65;1
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;295;0;65;3
WireConnection;300;0;297;0
WireConnection;10;0;6;3
WireConnection;42;0;309;0
WireConnection;101;0;100;0
WireConnection;101;1;106;0
WireConnection;101;2;99;0
WireConnection;311;1;299;0
WireConnection;311;2;300;0
WireConnection;75;0;65;4
WireConnection;32;0;31;0
WireConnection;34;0;37;2
WireConnection;48;0;47;0
WireConnection;48;1;61;0
WireConnection;5;0;2;0
WireConnection;164;0;183;0
WireConnection;164;1;165;0
WireConnection;164;2;142;0
WireConnection;199;0;135;0
WireConnection;14;0;11;2
WireConnection;43;0;310;0
WireConnection;294;0;292;0
WireConnection;9;0;6;1
WireConnection;296;0;295;0
WireConnection;59;0;311;0
WireConnection;312;1;294;0
WireConnection;312;2;296;0
WireConnection;200;0;201;0
WireConnection;200;1;199;0
WireConnection;63;0;68;0
WireConnection;63;1;67;0
WireConnection;49;0;48;0
WireConnection;53;0;52;2
WireConnection;104;0;101;0
WireConnection;104;1;107;0
WireConnection;104;2;102;0
WireConnection;167;0;164;0
WireConnection;167;1;142;0
WireConnection;167;2;169;0
WireConnection;282;0;283;0
WireConnection;211;0;200;2
WireConnection;194;0;135;0
WireConnection;118;0;116;0
WireConnection;118;1;115;0
WireConnection;118;2;117;0
WireConnection;140;0;135;0
WireConnection;77;0;312;0
WireConnection;18;0;39;0
WireConnection;18;1;20;0
WireConnection;18;2;19;0
WireConnection;105;0;104;0
WireConnection;105;1;108;0
WireConnection;105;2;103;0
WireConnection;170;0;167;0
WireConnection;209;0;200;1
WireConnection;70;0;63;0
WireConnection;90;0;87;0
WireConnection;90;1;88;0
WireConnection;90;2;86;0
WireConnection;73;0;65;2
WireConnection;234;0;211;0
WireConnection;195;0;196;0
WireConnection;195;1;194;0
WireConnection;123;0;118;0
WireConnection;123;1;120;0
WireConnection;123;2;119;0
WireConnection;144;0;170;0
WireConnection;141;0;136;0
WireConnection;141;1;140;0
WireConnection;233;0;209;0
WireConnection;277;0;280;0
WireConnection;277;2;281;0
WireConnection;277;1;282;0
WireConnection;204;0;135;0
WireConnection;78;0;18;0
WireConnection;78;1;80;0
WireConnection;78;2;79;0
WireConnection;94;0;90;0
WireConnection;94;1;89;0
WireConnection;94;2;91;0
WireConnection;109;0;105;0
WireConnection;255;0;141;0
WireConnection;255;1;256;0
WireConnection;124;0;123;0
WireConnection;124;1;122;0
WireConnection;124;2;121;0
WireConnection;197;0;195;0
WireConnection;95;0;94;0
WireConnection;95;1;93;0
WireConnection;95;2;92;0
WireConnection;81;0;78;0
WireConnection;81;1;83;0
WireConnection;81;2;82;0
WireConnection;205;0;206;0
WireConnection;205;1;204;0
WireConnection;278;0;277;0
WireConnection;278;1;279;0
WireConnection;237;0;238;0
WireConnection;237;1;236;0
WireConnection;237;2;239;0
WireConnection;145;0;255;0
WireConnection;125;0;124;0
WireConnection;207;0;205;0
WireConnection;21;0;81;0
WireConnection;285;0;278;0
WireConnection;275;0;274;0
WireConnection;275;1;276;0
WireConnection;96;0;95;0
WireConnection;284;0;285;0
WireConnection;284;1;275;0
WireConnection;230;0;229;0
WireConnection;230;1;231;0
WireConnection;240;0;237;0
WireConnection;240;1;241;0
WireConnection;215;0;214;0
WireConnection;215;1;218;0
WireConnection;215;2;217;0
WireConnection;155;0;153;0
WireConnection;155;1;159;0
WireConnection;155;2;147;0
WireConnection;272;0;284;0
WireConnection;242;0;240;0
WireConnection;227;0;220;0
WireConnection;227;1;230;0
WireConnection;227;2;228;0
WireConnection;224;0;227;0
WireConnection;216;0;215;0
WireConnection;158;0;155;0
WireConnection;288;0;253;0
WireConnection;288;1;289;0
WireConnection;290;0;253;0
WireConnection;290;1;291;0
WireConnection;112;0;110;0
WireConnection;112;1;113;0
WireConnection;202;0;200;0
WireConnection;235;0;210;0
WireConnection;210;0;200;3
WireConnection;17;0;6;4
WireConnection;168;0;167;0
WireConnection;168;1;169;0
WireConnection;0;0;22;0
WireConnection;0;1;126;0
WireConnection;0;2;290;0
WireConnection;0;4;112;0
WireConnection;0;5;97;0
WireConnection;0;11;288;0
ASEEND*/
//CHKSM=4AB9A6F5C00A6EF2ECB512210F505DBAD7E327B4