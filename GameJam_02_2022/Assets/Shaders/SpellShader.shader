// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SpellShader"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Scrolling("Scrolling", Range( 0 , 4)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HDR]_PatternColor("PatternColor", Color) = (0,0,0,0)
		_Float0("Float 0", Range( 0 , 1)) = 0
		_Float1("Float 1", Range( 1 , 12)) = 0
		_FresnelIntensity("Fresnel Intensity", Range( 0 , 4)) = 1
		_FresnelPower("FresnelPower", Range( 0 , 10)) = 0
		[HDR]_Color0("Color 0", Color) = (0,9.849155,9.656034,0)
		_DistorsionTwirlStrength("Distorsion Twirl Strength", Range( 0 , 4)) = 4
		_DistorsionSpeed("DistorsionSpeed", Range( 0 , 1)) = 0.2
		_DistorsionScale("Distorsion Scale", Range( 0 , 10)) = 4
		_Float4("Float 4", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _Float0;
		uniform float _Float1;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _DistorsionTwirlStrength;
		uniform float _DistorsionSpeed;
		uniform float _DistorsionScale;
		uniform float _Float4;
		uniform sampler2D _TextureSample1;
		uniform float _Scrolling;
		uniform sampler2D _TextureSample0;
		uniform float4 _PatternColor;
		uniform float _FresnelIntensity;
		uniform float _FresnelPower;
		uniform float4 _Color0;


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


		float3 PerturbNormal107_g5( float3 surf_pos, float3 surf_norm, float height, float scale )
		{
			// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
			float3 vSigmaS = ddx( surf_pos );
			float3 vSigmaT = ddy( surf_pos );
			float3 vN = surf_norm;
			float3 vR1 = cross( vSigmaT , vN );
			float3 vR2 = cross( vN , vSigmaS );
			float fDet = dot( vSigmaS , vR1 );
			float dBs = ddx( height );
			float dBt = ddy( height );
			float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
			return normalize ( abs( fDet ) * vN - vSurfGrad );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime69 = _Time.y * _Float0;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float simplePerlin2D72 = snoise( ( mulTime69 + ase_vertex3Pos ).xy*_Float1 );
			simplePerlin2D72 = simplePerlin2D72*0.5 + 0.5;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 VertexDisplacment78 = ( simplePerlin2D72 * ase_vertexNormal * 0.5 * 0.1 );
			v.vertex.xyz += VertexDisplacment78;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 surf_pos107_g5 = ase_worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 surf_norm107_g5 = ase_worldNormal;
			float2 temp_cast_0 = (0.5).xx;
			float2 center45_g4 = temp_cast_0;
			float2 delta6_g4 = ( i.uv_texcoord - center45_g4 );
			float angle10_g4 = ( length( delta6_g4 ) * _DistorsionTwirlStrength );
			float x23_g4 = ( ( cos( angle10_g4 ) * delta6_g4.x ) - ( sin( angle10_g4 ) * delta6_g4.y ) );
			float2 break40_g4 = center45_g4;
			float mulTime91 = _Time.y * _DistorsionSpeed;
			float2 temp_cast_1 = (mulTime91).xx;
			float2 break41_g4 = temp_cast_1;
			float y35_g4 = ( ( sin( angle10_g4 ) * delta6_g4.x ) + ( cos( angle10_g4 ) * delta6_g4.y ) );
			float2 appendResult44_g4 = (float2(( x23_g4 + break40_g4.x + break41_g4.x ) , ( break40_g4.y + break41_g4.y + y35_g4 )));
			float simplePerlin2D93 = snoise( appendResult44_g4*_DistorsionScale );
			simplePerlin2D93 = simplePerlin2D93*0.5 + 0.5;
			float height107_g5 = simplePerlin2D93;
			float scale107_g5 = _Float4;
			float3 localPerturbNormal107_g5 = PerturbNormal107_g5( surf_pos107_g5 , surf_norm107_g5 , height107_g5 , scale107_g5 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g5 = mul( ase_worldToTangent, localPerturbNormal107_g5);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 screenColor99 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float4( worldToTangentDir42_g5 , 0.0 ) + ase_screenPosNorm ).xy);
			float4 Distorsion100 = screenColor99;
			float2 _Vector0 = float2(1,1);
			float temp_output_56_0 = ( _Time.y * _Scrolling * 0.1 );
			float2 temp_cast_4 = (-temp_output_56_0).xx;
			float2 uv_TexCoord60 = i.uv_texcoord * _Vector0 + temp_cast_4;
			float2 temp_cast_5 = (temp_output_56_0).xx;
			float2 uv_TexCoord57 = i.uv_texcoord * _Vector0 + temp_cast_5;
			float4 PatternColor66 = ( ( tex2D( _TextureSample1, uv_TexCoord60 ).b + tex2D( _TextureSample0, uv_TexCoord57 ).b ) * _PatternColor );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV82 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode82 = ( 0.0 + _FresnelIntensity * pow( 1.0 - fresnelNdotV82, _FresnelPower ) );
			float4 FresnelColor85 = ( fresnelNode82 * _Color0 );
			float4 temp_output_48_0 = ( Distorsion100 + PatternColor66 + FresnelColor85 );
			o.Emission = temp_output_48_0.rgb;
			o.Alpha = temp_output_48_0.r;
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
1913;88;1920;923;2313.528;1371.839;1.898704;True;False
Node;AmplifyShaderEditor.CommentaryNode;101;-1615.308,603.6752;Inherit;False;2644;579.0001;Distorsion;14;88;89;91;90;92;93;95;96;94;97;98;99;100;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1457.883,-264.9297;Inherit;False;1999.482;642.6024;PatternColor;14;66;63;64;65;62;59;60;57;61;58;56;54;55;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1407.883,-49.08477;Inherit;False;Property;_Scrolling;Scrolling;1;0;Create;True;0;0;0;False;0;False;0;0.5;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;55;-1239.436,-119.7492;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1565.308,1032.675;Inherit;False;Property;_DistorsionSpeed;DistorsionSpeed;10;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1205.074,67.79722;Inherit;False;Constant;_01;0.1;0;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1128.713,832.1866;Inherit;False;Constant;_05;0.5;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1323.308,904.6752;Inherit;False;Property;_DistorsionTwirlStrength;Distorsion Twirl Strength;9;0;Create;True;0;0;0;False;0;False;4;4;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;91;-1213.308,1037.675;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1048.306,-54.92974;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;102;-1065.066,671.3969;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;94;-649.3083,1037.675;Inherit;False;Property;_DistorsionScale;Distorsion Scale;11;0;Create;True;0;0;0;False;0;False;4;4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;58;-1008.306,-214.9297;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;61;-952.3057,112.0703;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;88;-867.0856,794.1325;Inherit;True;Twirl;-1;;4;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1382.156,-1006.285;Inherit;False;1741;661;Vertex Displacement;11;68;69;70;71;72;73;74;75;76;77;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-746.3056,-147.9297;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;86;682.3145,-940.9154;Inherit;False;1250.519;483.825;Fresnel Color;6;80;81;82;83;84;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-362.3083,1066.675;Inherit;False;Property;_Float4;Float 4;12;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-798.3057,113.0703;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;93;-491.3083,844.6752;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1332.156,-773.2849;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-508.3056,-177.9297;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;6bce0bc1afd7b69408ab33eddacaacbc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-486.2685,153.6726;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;6bce0bc1afd7b69408ab33eddacaacbc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;732.6238,-671.6833;Inherit;False;Property;_FresnelIntensity;Fresnel Intensity;6;0;Create;True;0;0;0;False;0;False;1;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;71;-1123.156,-956.2849;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;732.3145,-573.0905;Inherit;False;Property;_FresnelPower;FresnelPower;7;0;Create;True;0;0;0;False;0;False;0;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;95;-80.3083,879.6752;Inherit;False;Normal From Height;-1;;5;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;98;154.6917,653.6752;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;69;-1017.156,-724.2849;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;82;1190.266,-688.3947;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;374.6917,822.6752;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;65;-103.9414,161.1;Inherit;False;Property;_PatternColor;PatternColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.5225452,1.459523,2.090181,0.1843137;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-927.1558,-587.2849;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0;2;1;12;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-803.1557,-767.2849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;84;1260.833,-890.9154;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0,9.849155,9.656034,0;0.6486768,1.891974,3.351497,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-153.4969,-98.48921;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;104.3734,-181.583;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;72;-641.1557,-716.2849;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1489.833,-761.9154;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;75;-452.1556,-845.2849;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-315.1556,-461.2849;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-433.1556,-575.2849;Inherit;False;Constant;_DisplacementRange;Displacement Range;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;99;591.6917,839.6752;Inherit;False;Global;_GrabScreen0;Grab Screen 0;11;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;804.6917,882.6752;Inherit;False;Distorsion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;1708.833,-731.9154;Inherit;False;FresnelColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;342.9762,-111.1482;Inherit;False;PatternColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-76.15549,-669.2849;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;923.8607,-5.260791;Inherit;False;66;PatternColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;921.8041,-100.2384;Inherit;False;100;Distorsion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;111.8445,-633.2849;Inherit;False;VertexDisplacment;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;939.3688,79.75001;Inherit;False;85;FresnelColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;1147.062,-16.45345;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;990.2089,223.2285;Inherit;False;78;VertexDisplacment;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;47;1343.953,-44.86914;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Custom/SpellShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;91;0;92;0
WireConnection;56;0;55;0
WireConnection;56;1;53;0
WireConnection;56;2;54;0
WireConnection;61;0;56;0
WireConnection;88;1;102;0
WireConnection;88;2;89;0
WireConnection;88;3;90;0
WireConnection;88;4;91;0
WireConnection;57;0;58;0
WireConnection;57;1;56;0
WireConnection;60;0;58;0
WireConnection;60;1;61;0
WireConnection;93;0;88;0
WireConnection;93;1;94;0
WireConnection;59;1;57;0
WireConnection;62;1;60;0
WireConnection;95;20;93;0
WireConnection;95;110;96;0
WireConnection;69;0;68;0
WireConnection;82;2;80;0
WireConnection;82;3;81;0
WireConnection;97;0;95;40
WireConnection;97;1;98;0
WireConnection;70;0;69;0
WireConnection;70;1;71;0
WireConnection;63;0;62;3
WireConnection;63;1;59;3
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;72;0;70;0
WireConnection;72;1;73;0
WireConnection;83;0;82;0
WireConnection;83;1;84;0
WireConnection;99;0;97;0
WireConnection;100;0;99;0
WireConnection;85;0;83;0
WireConnection;66;0;64;0
WireConnection;74;0;72;0
WireConnection;74;1;75;0
WireConnection;74;2;76;0
WireConnection;74;3;77;0
WireConnection;78;0;74;0
WireConnection;48;0;49;0
WireConnection;48;1;51;0
WireConnection;48;2;50;0
WireConnection;47;2;48;0
WireConnection;47;9;48;0
WireConnection;47;11;52;0
ASEEND*/
//CHKSM=AFF0262676C5661213932BF6ED91896449B3481B