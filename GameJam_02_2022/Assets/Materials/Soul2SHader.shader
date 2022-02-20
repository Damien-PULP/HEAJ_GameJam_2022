// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Soul2SHader"
{
	Properties
	{
		_Render("Render", 2D) = "white" {}
		_Alpha("Alpha", 2D) = "white" {}
		_Rows("Rows", Float) = 8
		_Columns("Columns", Float) = 8
		_Float0("Float 0", Range( 0 , 1)) = 0
		[Toggle]_AutoAnimate("AutoAnimate", Float) = 1
		_AnimationSpeed("Animation Speed", Float) = 1.01
		_OpacityBoost("OpacityBoost", Float) = 1
		_Vector0("Vector 0", Vector) = (0.63,0.5,0,0)
		_Scale("Scale", Float) = 1
		_Power("Power", Float) = 3.61
		_ScaleDIsplacement("ScaleDIsplacement", Float) = 0.04
		_PowerDisplacement("PowerDisplacement", Float) = 0.04
		_NoiseScale("Noise Scale", Float) = 18
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _ScaleDIsplacement;
		uniform float _PowerDisplacement;
		uniform float _NoiseScale;
		uniform float _Scale;
		uniform float _Power;
		uniform sampler2D _Render;
		uniform float2 _Vector0;
		uniform float _Columns;
		uniform float _Rows;
		uniform float _AutoAnimate;
		uniform float _Float0;
		uniform float _AnimationSpeed;
		uniform sampler2D _Alpha;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _OpacityBoost;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float fresnelNdotV33 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode33 = ( 0.0 + _ScaleDIsplacement * pow( 1.0 - fresnelNdotV33, _PowerDisplacement ) );
			float simplePerlin2D32 = snoise( v.texcoord.xy*_NoiseScale );
			simplePerlin2D32 = simplePerlin2D32*0.5 + 0.5;
			v.vertex.xyz += ( ( fresnelNode33 * simplePerlin2D32 ) * float3(1,1,1) );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV26 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
			float cos12 = cos( 0.0 );
			float sin12 = sin( 0.0 );
			float2 rotator12 = mul( i.uv_texcoord - _Vector0 , float2x2( cos12 , -sin12 , sin12 , cos12 )) + _Vector0;
			float mulTime2 = _Time.y * _AnimationSpeed;
			float clampResult6 = clamp( (( _AutoAnimate )?( frac( mulTime2 ) ):( _Float0 )) , 0.0 , 0.99 );
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles14 = _Columns * _Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset14 = 1.0f / _Columns;
			float fbrowsoffset14 = 1.0f / _Rows;
			// Speed of animation
			float fbspeed14 = ( clampResult6 * _Rows * _Columns ) * 1.0;
			// UV Tiling (col and row offset)
			float2 fbtiling14 = float2(fbcolsoffset14, fbrowsoffset14);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex14 = round( fmod( fbspeed14 + 0.0, fbtotaltiles14) );
			fbcurrenttileindex14 += ( fbcurrenttileindex14 < 0) ? fbtotaltiles14 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox14 = round ( fmod ( fbcurrenttileindex14, _Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx14 = fblinearindextox14 * fbcolsoffset14;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy14 = round( fmod( ( fbcurrenttileindex14 - fblinearindextox14 ) / _Columns, _Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy14 = (int)(_Rows-1) - fblinearindextoy14;
			// Multiply Offset Y by rowoffset
			float fboffsety14 = fblinearindextoy14 * fbrowsoffset14;
			// UV Offset
			float2 fboffset14 = float2(fboffsetx14, fboffsety14);
			// Flipbook UV
			half2 fbuv14 = rotator12 * fbtiling14 + fboffset14;
			// *** END Flipbook UV Animation vars ***
			o.Emission = ( fresnelNode26 * tex2D( _Render, fbuv14 ) ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth16 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth16 = saturate( abs( ( screenDepth16 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) ) );
			float fresnelNdotV20 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode20 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV20, _Power ) );
			o.Alpha = ( ( tex2D( _Alpha, fbuv14 ).r * distanceDepth16 * _OpacityBoost ) * fresnelNode20 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
1913;18;1920;993;667.5852;57.84192;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-2503.597,400.8746;Inherit;False;Property;_AnimationSpeed;Animation Speed;6;0;Create;True;0;0;0;False;0;False;1.01;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-2245.94,398.356;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2208.395,262.1178;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;4;-2050.94,397.356;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;5;-1883.94,334.3561;Inherit;False;Property;_AutoAnimate;AutoAnimate;5;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;6;-1688.682,260.4933;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;7;-1974.524,-59.47115;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1836.431,188.8233;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1574.903,544.45;Inherit;False;Property;_Rows;Rows;2;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1796.05,89.49478;Inherit;False;Property;_Columns;Columns;3;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-1747.431,-146.1767;Inherit;False;Property;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0.63,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1507.295,278.4176;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;12;-1529.73,29.92848;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;14;-1229.042,167.7447;Inherit;True;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;31;-195.4341,651.8895;Inherit;False;Property;_PowerDisplacement;PowerDisplacement;12;0;Create;True;0;0;0;False;0;False;0.04;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;30;-144.934,722.0894;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;137.4808,781.1749;Inherit;False;Property;_NoiseScale;Noise Scale;13;0;Create;True;0;0;0;False;0;False;18;31.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-186.4341,538.8896;Inherit;False;Property;_ScaleDIsplacement;ScaleDIsplacement;11;0;Create;True;0;0;0;False;0;False;0.04;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;33;0.08973694,454.0043;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;232.566,658.8895;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-699.3204,246.7962;Inherit;False;Property;_Power;Power;10;0;Create;True;0;0;0;False;0;False;3.61;3.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-566.3204,267.7962;Inherit;False;Property;_Scale;Scale;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;22;-252.7448,-283.8145;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;21;-78.42893,-85.07321;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;17;-923.8147,643.9824;Inherit;False;Property;_OpacityBoost;OpacityBoost;7;0;Create;True;0;0;0;False;0;False;1;2.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;16;-1009.587,540.1388;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-822.1732,339.6124;Inherit;True;Property;_Alpha;Alpha;1;0;Create;True;0;0;0;False;0;False;-1;fa688aedbacbf5e4fac6ef09be5ce874;a4fe9ba85fd7ebc4f80a78b34b784d0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;20;31.99612,-321.515;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;26;213.9828,-48.92374;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;35;543.0809,631.675;Inherit;False;Constant;_Vector1;Vector 1;14;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-385.6343,369.3207;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-642.9932,27.40995;Inherit;True;Property;_Render;Render;0;0;Create;True;0;0;0;False;0;False;-1;fa688aedbacbf5e4fac6ef09be5ce874;a4fe9ba85fd7ebc4f80a78b34b784d0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;323.2662,399.4896;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;562.5197,-77.73761;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;544.7227,135.166;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;544.3807,482.1751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1039.05,-13.57771;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Custom/Soul2SHader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;4;0;2;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;6;0;5;0
WireConnection;13;0;6;0
WireConnection;13;1;11;0
WireConnection;13;2;9;0
WireConnection;12;0;7;0
WireConnection;12;1;10;0
WireConnection;12;2;8;0
WireConnection;14;0;12;0
WireConnection;14;1;9;0
WireConnection;14;2;11;0
WireConnection;14;5;13;0
WireConnection;33;2;28;0
WireConnection;33;3;31;0
WireConnection;32;0;30;0
WireConnection;32;1;29;0
WireConnection;15;1;14;0
WireConnection;20;0;21;0
WireConnection;20;4;22;0
WireConnection;20;2;23;0
WireConnection;20;3;24;0
WireConnection;26;0;21;0
WireConnection;26;4;22;0
WireConnection;26;2;23;0
WireConnection;26;3;24;0
WireConnection;19;0;15;1
WireConnection;19;1;16;0
WireConnection;19;2;17;0
WireConnection;18;1;14;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;27;0;26;0
WireConnection;27;1;18;0
WireConnection;25;0;19;0
WireConnection;25;1;20;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;0;2;27;0
WireConnection;0;9;25;0
WireConnection;0;11;36;0
ASEEND*/
//CHKSM=FE5B227FC3ED25F7395A4FA3561F3C8B6E4079C6