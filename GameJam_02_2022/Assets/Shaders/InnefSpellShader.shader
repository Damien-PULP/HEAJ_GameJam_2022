// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/InnefSpellShader"
{
	Properties
	{
		_Float1("Float 1", Float) = 1
		_Power("Power", Float) = 1
		_Power2("Power2", Float) = 1
		_Float0("Float 0", Float) = 1
		_Scale("Scale", Float) = 1
		_Scale2("Scale2", Float) = 1
		[HDR]_Color0("Color 0", Color) = (0,0.325516,1,0)
		[HDR]_Color1("Color 1", Color) = (0,0.325516,1,0)
		_Float2("Float 2", Range( 0 , 1)) = 0.5
		_Texture0("Texture 0", 2D) = "white" {}
		_DisplacementRange("Displacement Range", Range( 0 , 1)) = 0.5
		_Float3("Float 3", Float) = 0.1
		[HDR]_Color2("Color 2", Color) = (1,0,0,0)
		[HDR]_Color3("Color 3", Color) = (1,0,0,0)
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
		};

		uniform sampler2D _Texture0;
		uniform float _Float2;
		uniform float _DisplacementRange;
		uniform float _Float3;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Float0;
		uniform float _Float1;
		uniform float4 _Color2;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _Color3;
		uniform float _Scale2;
		uniform float _Power2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime10 = _Time.y * _Float2;
			float3 ase_vertexNormal = v.normal.xyz;
			float4 VertexDisplacment19 = ( tex2Dlod( _Texture0, float4( ( ase_vertex3Pos + mulTime10 ).xy, 0, 0.0) ) * float4( ase_vertexNormal , 0.0 ) * _DisplacementRange * _Float3 );
			v.vertex.xyz += VertexDisplacment19.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode1 = ( 0.0 + _Float0 * pow( 1.0 - fresnelNdotV1, _Float1 ) );
			float4 lerpResult21 = lerp( _Color0 , _Color1 , saturate( fresnelNode1 ));
			float fresnelNdotV27 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode27 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV27, _Power ) );
			float4 lerpResult30 = lerp( lerpResult21 , _Color2 , saturate( fresnelNode27 ));
			float fresnelNdotV44 = dot( ase_worldNormal, i.viewDir );
			float fresnelNode44 = ( 0.0 + _Scale2 * pow( 1.0 - fresnelNdotV44, _Power2 ) );
			float4 lerpResult50 = lerp( lerpResult30 , _Color3 , saturate( fresnelNode44 ));
			o.Emission = lerpResult50.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
1920;0;1920;1011;1188.763;382.0523;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-1612.789,588.3015;Inherit;False;Property;_Float2;Float 2;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1298.188,330.9016;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1277.388,658.5016;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;3;-992.5006,-253.9828;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-800.8475,175.011;Inherit;False;Property;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;1;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2;-946.8475,-90.98904;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1040.848,18.01096;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;1;2.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-164.2475,-20.21165;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;1;14.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-747.2925,-52.39478;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;25;-225.4579,-90.61098;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-926.3882,613.0015;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-961.0197,387.2825;Inherit;True;Property;_Texture0;Texture 0;9;0;Create;True;0;0;0;False;0;False;04acbae515bedef47892a8c7b7cf9711;0621e8efdb88aa549853a96496ea3adb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldNormalVector;29;-217.5607,-224.9652;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;26;-112.763,73.11729;Inherit;False;Property;_Power;Power;1;0;Create;True;0;0;0;False;0;False;1;4.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;46;563.01,-123.3202;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-369.2197,818.8824;Inherit;False;Property;_DisplacementRange;Displacement Range;10;0;Create;True;0;0;0;False;0;False;0.5;0.414;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-608.0197,632.2825;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;23;-507.3408,-65.15204;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;667.8076,174.7622;Inherit;False;Property;_Power2;Power2;2;0;Create;True;0;0;0;False;0;False;1;4.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-216.7346,-415.834;Inherit;False;Property;_Color1;Color 1;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0.325516,1,0;0.1368369,0.5877309,0.7075472,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;632.3231,80.4333;Inherit;False;Property;_Scale2;Scale2;5;0;Create;True;0;0;0;False;0;False;1;-6.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-266.2197,915.8824;Inherit;False;Property;_Float3;Float 3;11;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;18;-403.2197,531.8824;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-218.7169,-616.1795;Inherit;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0.325516,1,0;1.293094,6.675163,4.948458,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;45;417.1128,-0.9659767;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;27;106.1877,-150.5379;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;44;898.7582,-45.89291;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;239.0375,-318.6406;Inherit;False;Property;_Color2;Color 2;12;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0.2342444,1.009053,0.9549963,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;28;369.2221,-156.9995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-27.21954,707.8824;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;72.59462,-378.2119;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;43;1149.793,-55.35447;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;160.7804,743.8824;Inherit;False;VertexDisplacment;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;30;557.4395,-409.6053;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;49;981.908,-254.6955;Inherit;False;Property;_Color3;Color 3;13;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0.6666667,0.9411765,1.513726,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1062.02,745.2825;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;20;-408.2245,332.156;Inherit;False;19;VertexDisplacment;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;50;1378.369,-382.8852;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1581.68,-291.0215;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/InnefSpellShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;11;0
WireConnection;1;0;3;0
WireConnection;1;4;2;0
WireConnection;1;2;4;0
WireConnection;1;3;5;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;12;0;14;0
WireConnection;12;1;9;0
WireConnection;23;0;1;0
WireConnection;27;0;29;0
WireConnection;27;4;25;0
WireConnection;27;2;24;0
WireConnection;27;3;26;0
WireConnection;44;0;46;0
WireConnection;44;4;45;0
WireConnection;44;2;47;0
WireConnection;44;3;48;0
WireConnection;28;0;27;0
WireConnection;17;0;12;0
WireConnection;17;1;18;0
WireConnection;17;2;16;0
WireConnection;17;3;15;0
WireConnection;21;0;7;0
WireConnection;21;1;22;0
WireConnection;21;2;23;0
WireConnection;43;0;44;0
WireConnection;19;0;17;0
WireConnection;30;0;21;0
WireConnection;30;1;31;0
WireConnection;30;2;28;0
WireConnection;50;0;30;0
WireConnection;50;1;49;0
WireConnection;50;2;43;0
WireConnection;0;2;50;0
WireConnection;0;11;20;0
ASEEND*/
//CHKSM=FCB3C93621AD45BF1E5D03884FD60E57105C1E45