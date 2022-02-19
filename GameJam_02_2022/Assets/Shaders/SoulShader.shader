// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SoulShader"
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
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

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

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float cos17 = cos( 0.0 );
			float sin17 = sin( 0.0 );
			float2 rotator17 = mul( i.uv_texcoord - _Vector0 , float2x2( cos17 , -sin17 , sin17 , cos17 )) + _Vector0;
			float mulTime2 = _Time.y * _AnimationSpeed;
			float clampResult7 = clamp( (( _AutoAnimate )?( frac( mulTime2 ) ):( _Float0 )) , 0.0 , 0.99 );
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles10 = _Columns * _Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset10 = 1.0f / _Columns;
			float fbrowsoffset10 = 1.0f / _Rows;
			// Speed of animation
			float fbspeed10 = ( clampResult7 * _Rows * _Columns ) * 1.0;
			// UV Tiling (col and row offset)
			float2 fbtiling10 = float2(fbcolsoffset10, fbrowsoffset10);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex10 = round( fmod( fbspeed10 + 0.0, fbtotaltiles10) );
			fbcurrenttileindex10 += ( fbcurrenttileindex10 < 0) ? fbtotaltiles10 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox10 = round ( fmod ( fbcurrenttileindex10, _Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx10 = fblinearindextox10 * fbcolsoffset10;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy10 = round( fmod( ( fbcurrenttileindex10 - fblinearindextox10 ) / _Columns, _Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy10 = (int)(_Rows-1) - fblinearindextoy10;
			// Multiply Offset Y by rowoffset
			float fboffsety10 = fblinearindextoy10 * fbrowsoffset10;
			// UV Offset
			float2 fboffset10 = float2(fboffsetx10, fboffsety10);
			// Flipbook UV
			half2 fbuv10 = rotator17 * fbtiling10 + fboffset10;
			// *** END Flipbook UV Animation vars ***
			o.Emission = tex2D( _Render, fbuv10 ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth12 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth12 = saturate( abs( ( screenDepth12 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) ) );
			o.Alpha = ( tex2D( _Alpha, fbuv10 ).r * distanceDepth12 * _OpacityBoost );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
-275;967;1920;1011;2054.528;309.6266;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-2240.693,304.4247;Inherit;False;Property;_AnimationSpeed;Animation Speed;6;0;Create;True;0;0;0;False;0;False;1.01;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1983.037,301.9061;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1945.491,165.6679;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0.536;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;3;-1788.037,300.9061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;5;-1621.037,237.9062;Inherit;False;Property;_AutoAnimate;AutoAnimate;5;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1573.528,92.37335;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;15;-1711.621,-155.9211;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1454.147,15.04483;Inherit;False;Property;_Rows;Rows;2;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;18;-1507.528,-2.626648;Inherit;False;Property;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0.63,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;6;-1461.147,-71.95518;Inherit;False;Property;_Columns;Columns;3;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;7;-1425.778,164.0434;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;17;-1266.826,-66.52147;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1244.391,181.9676;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;10;-966.1387,71.29473;Inherit;True;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;11;-559.2697,243.1624;Inherit;True;Property;_Alpha;Alpha;1;0;Create;True;0;0;0;False;0;False;-1;fa688aedbacbf5e4fac6ef09be5ce874;a4fe9ba85fd7ebc4f80a78b34b784d0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;12;-549.9832,537.8362;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-306.1776,463.4723;Inherit;False;Property;_OpacityBoost;OpacityBoost;7;0;Create;True;0;0;0;False;0;False;1;2.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-146.7309,311.8708;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-380.0897,-69.03999;Inherit;True;Property;_Render;Render;0;0;Create;True;0;0;0;False;0;False;-1;fa688aedbacbf5e4fac6ef09be5ce874;a4fe9ba85fd7ebc4f80a78b34b784d0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;116,67;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Custom/SoulShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;5;0;4;0
WireConnection;5;1;3;0
WireConnection;7;0;5;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;17;2;19;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;9;2;6;0
WireConnection;10;0;17;0
WireConnection;10;1;6;0
WireConnection;10;2;8;0
WireConnection;10;5;9;0
WireConnection;11;1;10;0
WireConnection;14;0;11;1
WireConnection;14;1;12;0
WireConnection;14;2;16;0
WireConnection;13;1;10;0
WireConnection;0;2;13;0
WireConnection;0;9;14;0
ASEEND*/
//CHKSM=BB576F95FA168BDC1A6B7C0FFC981CFD485C4C64