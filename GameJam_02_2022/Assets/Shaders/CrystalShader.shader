// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShader/CrystalShader"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[HDR]_AlbedoColor("Albedo Color", Color) = (1,1,1,0)
		[NoScaleOffset]_EmissionBase("Emission Base", 2D) = "white" {}
		[NoScaleOffset]_EmissionCurvature("Emission Curvature", 2D) = "white" {}
		[HDR]_EmissionBaseColor("Emission Base Color", Color) = (1,1,1,0)
		[HDR]_EmissionEdgeColor("EmissionEdgeColor", Color) = (1,1,1,0)
		[HDR]_EmissionCurvatureColor("Emission Curvature Color", Color) = (1,1,1,0)
		_SpeedNoiseVariationEmission("SpeedNoiseVariationEmission", Float) = 0
		_ScaleNoiseVariationEmission("ScaleNoiseVariationEmission", Float) = 0
		[NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
		[NoScaleOffset]_Metalness("Metalness", 2D) = "white" {}
		[NoScaleOffset]_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_FresnelPower("FresnelPower", Float) = 0
		_FresnelScale("FresnelScale", Float) = 0
		_FresnelBias("FresnelBias", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _AlbedoColor;
		uniform sampler2D _Albedo;
		uniform sampler2D _EmissionBase;
		uniform float4 _EmissionBaseColor;
		uniform float4 _EmissionEdgeColor;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _SpeedNoiseVariationEmission;
		uniform float _ScaleNoiseVariationEmission;
		uniform sampler2D _EmissionCurvature;
		uniform float4 _EmissionCurvatureColor;
		uniform sampler2D _Metalness;
		uniform sampler2D _Roughness;
		uniform sampler2D _AmbientOcclusion;


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
			float2 uv_Albedo14 = i.uv_texcoord;
			float4 Albedo49 = ( _AlbedoColor * tex2D( _Albedo, uv_Albedo14 ) );
			o.Albedo = Albedo49.rgb;
			float2 uv_EmissionBase11 = i.uv_texcoord;
			float4 EmissionBaseTexture62 = tex2D( _EmissionBase, uv_EmissionBase11 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV27 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode27 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV27, _FresnelPower ) );
			float FresnelValue51 = saturate( fresnelNode27 );
			float4 lerpResult29 = lerp( _EmissionBaseColor , _EmissionEdgeColor , FresnelValue51);
			float2 temp_cast_1 = (_SpeedNoiseVariationEmission).xx;
			float2 panner40 = ( 1.0 * _Time.y * temp_cast_1 + i.uv_texcoord);
			float simpleNoise38 = SimpleNoise( panner40*_ScaleNoiseVariationEmission );
			float lerpResult46 = lerp( 0.6 , 1.6 , simpleNoise38);
			float NoiseEmission57 = lerpResult46;
			float2 uv_EmissionCurvature22 = i.uv_texcoord;
			float4 EmissionCurvatureTexture63 = tex2D( _EmissionCurvature, uv_EmissionCurvature22 );
			float4 Emission50 = ( ( EmissionBaseTexture62 * lerpResult29 * NoiseEmission57 ) + ( EmissionCurvatureTexture63 * _EmissionCurvatureColor ) );
			o.Emission = Emission50.rgb;
			float2 uv_Metalness18 = i.uv_texcoord;
			float4 Metalness69 = tex2D( _Metalness, uv_Metalness18 );
			o.Metallic = Metalness69.r;
			float4 temp_cast_4 = (FresnelValue51).xxxx;
			float2 uv_Roughness9 = i.uv_texcoord;
			float4 Smoothness68 = ( 1.0 - min( temp_cast_4 , tex2D( _Roughness, uv_Roughness9 ) ) );
			o.Smoothness = Smoothness68.r;
			float2 uv_AmbientOcclusion3 = i.uv_texcoord;
			float4 AmbientOcclusion70 = tex2D( _AmbientOcclusion, uv_AmbientOcclusion3 );
			o.Occlusion = AmbientOcclusion70.r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
1920;0;1920;1011;5196.447;1143.028;2.397898;True;False
Node;AmplifyShaderEditor.CommentaryNode;67;-3946.199,-1001.157;Inherit;False;1611.051;2400.472;Emission Preperties;8;66;60;59;56;57;62;63;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-3872.051,979.7131;Inherit;False;1020.736;419.6008;Fresnel;6;34;31;33;27;28;51;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;56;-3871.297,385.5904;Inherit;False;1264.422;566.6176;Noise Emission;8;43;39;40;38;42;48;46;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-3822.051,1180.314;Inherit;False;Property;_FresnelScale;FresnelScale;13;0;Create;True;0;0;0;False;0;False;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3811.051,1283.314;Inherit;False;Property;_FresnelPower;FresnelPower;12;0;Create;True;0;0;0;False;0;False;0;1.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-3810.025,621.0646;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-3821.297,758.8293;Inherit;False;Property;_SpeedNoiseVariationEmission;SpeedNoiseVariationEmission;7;0;Create;True;0;0;0;False;0;False;0;1.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-3788.051,1065.314;Inherit;False;Property;_FresnelBias;FresnelBias;14;0;Create;True;0;0;0;False;0;False;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;60;-3866.171,-132.9324;Inherit;False;677.9001;484.3239;Texture emission;4;22;24;11;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3806.385,836.2079;Inherit;False;Property;_ScaleNoiseVariationEmission;ScaleNoiseVariationEmission;8;0;Create;True;0;0;0;False;0;False;0;4.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;40;-3438.94,623.7958;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;27;-3528.121,1029.713;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;24;-3816.171,-82.93247;Inherit;True;Property;_EmissionCurvature;Emission Curvature;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;ab0e7504220a8214186d2de304f9e78c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;28;-3276.25,1078.043;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-3812.075,121.3914;Inherit;True;Property;_EmissionBase;Emission Base;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;aaf2bc11d1f50fb4f9ce1729e2582851;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;48;-3180.276,516.0024;Inherit;False;Constant;_MaxIntensityNoiseEmission;MaxIntensityNoiseEmission;15;0;Create;True;0;0;0;False;0;False;1.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-3178.199,593.1345;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-3179.38,435.5902;Inherit;False;Constant;_MinIntensityNoiseEmission;MinIntensityNoiseEmission;15;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-3509.475,119.3914;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;46;-2877.876,433.6793;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-3075.314,1075.761;Inherit;False;FresnelValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-3884.499,-947.2573;Inherit;False;1165.774;699.3031;ColorEmission;11;23;64;25;58;29;52;21;30;65;16;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;22;-3508.271,-76.03257;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;74;-2273.683,73.2716;Inherit;False;1242.29;1310.075;Base Material;17;9;53;37;17;68;18;69;3;70;5;10;1;13;14;20;19;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-3067.713,-60.15309;Inherit;False;EmissionCurvatureTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;30;-3844.499,-600.258;Inherit;False;Property;_EmissionEdgeColor;EmissionEdgeColor;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,3.516575,12.99604,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;5;-2223.553,721.2476;Inherit;True;Property;_Roughness;Roughness;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;62f9145cf6f6bdb4eaad3365dbee4222;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;52;-3819.517,-424.9546;Inherit;False;51;FresnelValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-3063.713,145.8469;Inherit;False;EmissionBaseTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-3844.455,-782.2576;Inherit;False;Property;_EmissionBaseColor;Emission Base Color;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,2.512648,3.482202,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-2559.148,434.7322;Inherit;False;NoiseEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-2258.683,302.7774;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;356d0aee315d1fd4e8c6eefb39e958c8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;65;-3560.012,-887.253;Inherit;False;62;EmissionBaseTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-3556.012,-526.2532;Inherit;False;63;EmissionCurvatureTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;29;-3562.725,-781.5371;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-1975.026,716.6145;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;25;-3547.642,-447.0706;Inherit;False;Property;_EmissionCurvatureColor;Emission Curvature Color;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0.8490566,0.8490566,0.8490566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;58;-3331.075,-711.3415;Inherit;False;57;NoiseEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1878.605,569.5634;Inherit;False;51;FresnelValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;37;-1646.981,632.5324;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3237.206,-472.2954;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;-1968.767,302.9739;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3091.646,-836.7844;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-1879.282,123.2716;Inherit;False;Property;_AlbedoColor;Albedo Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0.3685272,1.135301,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2201.776,1150.747;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;797e4a65b381720478c8e0f3d9538861;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;10;-2196.026,934.9619;Inherit;True;Property;_Metalness;Metalness;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;53b21f03064aa074785374773d7d9886;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;17;-1485.985,634.1059;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2982.485,-615.0942;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1906.975,1151.347;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1915.928,934.6599;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1566.531,131.445;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-1357.237,128.3654;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-1499.266,918.064;Inherit;False;Metalness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2660.705,-614.9409;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1555.41,1148.742;Inherit;False;AmbientOcclusion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1255.393,633.6566;Inherit;False;Smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1578.871,-322.0529;Inherit;False;50;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1579.471,-405.453;Inherit;False;49;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1622.754,-70.37948;Inherit;False;70;AmbientOcclusion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-1595.754,-156.3794;Inherit;False;68;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-1579.754,-235.3795;Inherit;False;69;Metalness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1265.215,-414.5293;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShader/CrystalShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;39;0
WireConnection;40;2;42;0
WireConnection;27;1;31;0
WireConnection;27;2;34;0
WireConnection;27;3;33;0
WireConnection;28;0;27;0
WireConnection;38;0;40;0
WireConnection;38;1;43;0
WireConnection;11;0;4;0
WireConnection;46;0;47;0
WireConnection;46;1;48;0
WireConnection;46;2;38;0
WireConnection;51;0;28;0
WireConnection;22;0;24;0
WireConnection;63;0;22;0
WireConnection;62;0;11;0
WireConnection;57;0;46;0
WireConnection;29;0;21;0
WireConnection;29;1;30;0
WireConnection;29;2;52;0
WireConnection;9;0;5;0
WireConnection;37;0;53;0
WireConnection;37;1;9;0
WireConnection;23;0;64;0
WireConnection;23;1;25;0
WireConnection;14;0;13;0
WireConnection;16;0;65;0
WireConnection;16;1;29;0
WireConnection;16;2;58;0
WireConnection;17;0;37;0
WireConnection;26;0;16;0
WireConnection;26;1;23;0
WireConnection;3;0;1;0
WireConnection;18;0;10;0
WireConnection;19;0;20;0
WireConnection;19;1;14;0
WireConnection;49;0;19;0
WireConnection;69;0;18;0
WireConnection;50;0;26;0
WireConnection;70;0;3;0
WireConnection;68;0;17;0
WireConnection;0;0;54;0
WireConnection;0;2;55;0
WireConnection;0;3;72;0
WireConnection;0;4;73;0
WireConnection;0;5;71;0
ASEEND*/
//CHKSM=12617BAA3612A38A7A8F5C05AC4D26C1344B6382