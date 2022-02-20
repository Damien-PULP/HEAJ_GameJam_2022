// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/InnefSpellShader"
{
	Properties
	{
		_Power1("Power1", Float) = 1
		_Power2("Power2", Float) = 1
		_Power3("Power3", Float) = 1
		_Scale1("Scale1", Float) = 1
		_Scale2("Scale2", Float) = 1
		_Scale3("Scale3", Float) = 1
		[HDR]_Color0("Color 0", Color) = (0,0.325516,1,0)
		[HDR]_Color1("Color 1", Color) = (0,0.325516,1,0)
		_Float2("Float 2", Range( 0 , 1)) = 0.5
		_Texture0("Texture 0", 2D) = "white" {}
		_DisplacementRange("Displacement Range", Range( 0 , 1)) = 0.5
		_Float3("Float 3", Float) = 0.1
		[HDR]_Color2("Color 2", Color) = (1,0,0,0)
		[HDR]_Color3("Color 3", Color) = (1,0,0,0)
		_ScalePerlin1("ScalePerlin1", Float) = 3.59
		_ScalePerlin3("ScalePerlin3", Float) = 4.26
		_Texture1("Texture 1", 2D) = "white" {}
		_SmoothstepMax("SmoothstepMax", Float) = 0
		_NoiseTIlling("NoiseTIlling", Vector) = (0,0,0,0)
		_SmoothstepMin("SmoothstepMin", Float) = 0
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Texture0;
		uniform float _Float2;
		uniform float _DisplacementRange;
		uniform float _Float3;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _ScalePerlin3;
		uniform float _Scale1;
		uniform float _Power1;
		uniform float4 _Color2;
		uniform float _ScalePerlin1;
		uniform float _Scale2;
		uniform float _Power2;
		uniform float4 _Color3;
		uniform float _SmoothstepMin;
		uniform float _SmoothstepMax;
		uniform sampler2D _Texture1;
		uniform float2 _NoiseTIlling;
		uniform float _Scale3;
		uniform float _Power3;


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
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime10 = _Time.y * _Float2;
			float3 ase_vertexNormal = v.normal.xyz;
			float4 VertexDisplacment19 = ( tex2Dlod( _Texture0, float4( ( ase_vertex3Pos + mulTime10 ).xy, 0, 0.0) ) * float4( ase_vertexNormal , 0.0 ) * _DisplacementRange * _Float3 );
			v.vertex.xyz += VertexDisplacment19.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float simplePerlin2D64 = snoise( i.uv_texcoord*_ScalePerlin3 );
			simplePerlin2D64 = simplePerlin2D64*0.5 + 0.5;
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ( i.viewDir * simplePerlin2D64 ) );
			float fresnelNode1 = ( 0.0 + _Scale1 * pow( 1.0 - fresnelNdotV1, _Power1 ) );
			float4 lerpResult21 = lerp( _Color0 , _Color1 , saturate( fresnelNode1 ));
			float simplePerlin2D59 = snoise( i.uv_texcoord*_ScalePerlin1 );
			simplePerlin2D59 = simplePerlin2D59*0.5 + 0.5;
			float fresnelNdotV27 = dot( ase_worldNormal, ( i.viewDir * simplePerlin2D59 ) );
			float fresnelNode27 = ( 0.0 + _Scale2 * pow( 1.0 - fresnelNdotV27, _Power2 ) );
			float4 lerpResult30 = lerp( lerpResult21 , _Color2 , saturate( fresnelNode27 ));
			float4 temp_cast_1 = (_SmoothstepMin).xxxx;
			float4 temp_cast_2 = (_SmoothstepMax).xxxx;
			float2 uv_TexCoord67 = i.uv_texcoord * _NoiseTIlling;
			float4 smoothstepResult69 = smoothstep( temp_cast_1 , temp_cast_2 , tex2D( _Texture1, uv_TexCoord67 ));
			float fresnelNdotV44 = dot( ase_worldNormal, ( float4( i.viewDir , 0.0 ) * smoothstepResult69 ).rgb );
			float fresnelNode44 = ( 0.0 + _Scale3 * pow( 1.0 - fresnelNdotV44, _Power3 ) );
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
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
1920;0;1920;1011;318.8942;-59.36639;1;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;63;-1719.032,1.920172;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-1674.494,144.5433;Inherit;False;Property;_ScalePerlin3;ScalePerlin3;15;0;Create;True;0;0;0;False;0;False;4.26;4.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;68;43.11102,394.7598;Inherit;False;Property;_NoiseTIlling;NoiseTIlling;18;0;Create;True;0;0;0;False;0;False;0,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;11;-1612.789,588.3015;Inherit;False;Property;_Float2;Float 2;8;0;Create;True;0;0;0;False;0;False;0.5;0.466;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;64;-1540.242,60.55967;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;58;-651.2085,232.0096;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;61;-1531.756,-144.7746;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;57;-612.3708,375.8328;Inherit;False;Property;_ScalePerlin1;ScalePerlin1;14;0;Create;True;0;0;0;False;0;False;3.59;1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;195.111,307.7598;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;65;112.111,458.7598;Inherit;True;Property;_Texture1;Texture 1;16;0;Create;True;0;0;0;False;0;False;None;cd3daa159e27d564187eecdcae3dde21;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;66;376.111,378.7598;Inherit;True;Property;_TextureSample1;Texture Sample 1;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;622.1058,657.3664;Inherit;False;Property;_SmoothstepMax;SmoothstepMax;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;59;-472.4189,290.6492;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1295.719,-120.5355;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;70;603.111,564.7598;Inherit;False;Property;_SmoothstepMin;SmoothstepMin;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-800.8475,175.011;Inherit;False;Property;_Power1;Power1;0;0;Create;True;0;0;0;False;0;False;1;4.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1277.388,658.5016;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;3;-992.5006,-253.9828;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1040.848,18.01096;Inherit;False;Property;_Scale1;Scale1;3;0;Create;True;0;0;0;False;0;False;1;4.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;56;-463.9325,85.31487;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1298.188,330.9016;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;69;793.111,425.7598;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-32.6603,71.34996;Inherit;False;Property;_Power2;Power2;1;0;Create;True;0;0;0;False;0;False;1;3.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-926.3882,613.0015;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;1;-747.2925,-52.39478;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-117.1448,-43.97894;Inherit;False;Property;_Scale2;Scale2;4;0;Create;True;0;0;0;False;0;False;1;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;29;-217.5607,-224.9652;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-227.8961,109.5539;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-961.0197,387.2825;Inherit;True;Property;_Texture0;Texture 0;9;0;Create;True;0;0;0;False;0;False;04acbae515bedef47892a8c7b7cf9711;0621e8efdb88aa549853a96496ea3adb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;45;297.3715,23.30614;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;12;-608.0197,632.2825;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;763.6422,90.80059;Inherit;False;Property;_Scale3;Scale3;5;0;Create;True;0;0;0;False;0;False;1;1.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;533.4079,47.54517;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-218.7169,-616.1795;Inherit;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0.325516,1,0;0.9716122,4.438811,5.885195,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;27;106.1877,-150.5379;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-369.2197,818.8824;Inherit;False;Property;_DisplacementRange;Displacement Range;10;0;Create;True;0;0;0;False;0;False;0.5;0.571;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;46;563.01,-123.3202;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;18;-403.2197,531.8824;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;799.3988,209.2314;Inherit;False;Property;_Power3;Power3;2;0;Create;True;0;0;0;False;0;False;1;1.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-266.2197,915.8824;Inherit;False;Property;_Float3;Float 3;11;0;Create;True;0;0;0;False;0;False;0.1;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-216.7346,-415.834;Inherit;False;Property;_Color1;Color 1;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0.325516,1,0;1.572031,2.215923,4.114452,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;23;-507.3408,-65.15204;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;44;898.7582,-45.89291;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;369.2221,-156.9995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-27.21954,707.8824;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;72.59462,-378.2119;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;31;239.0375,-318.6406;Inherit;False;Property;_Color2;Color 2;12;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;7.833981,10.97212,28.14922,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;160.7804,743.8824;Inherit;False;VertexDisplacment;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;49;981.908,-254.6955;Inherit;False;Property;_Color3;Color 3;13;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0.4105377,1.355724,1.582436,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;43;1149.793,-55.35447;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;557.4395,-409.6053;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1062.02,745.2825;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;20;1407.887,-9.870392;Inherit;False;19;VertexDisplacment;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;54;110.0956,170.0009;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;50;1378.369,-382.8852;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1687.66,-352.0403;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/InnefSpellShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;64;0;63;0
WireConnection;64;1;62;0
WireConnection;67;0;68;0
WireConnection;66;0;65;0
WireConnection;66;1;67;0
WireConnection;59;0;58;0
WireConnection;59;1;57;0
WireConnection;60;0;61;0
WireConnection;60;1;64;0
WireConnection;10;0;11;0
WireConnection;69;0;66;0
WireConnection;69;1;70;0
WireConnection;69;2;71;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;1;0;3;0
WireConnection;1;4;60;0
WireConnection;1;2;4;0
WireConnection;1;3;5;0
WireConnection;55;0;56;0
WireConnection;55;1;59;0
WireConnection;12;0;14;0
WireConnection;12;1;9;0
WireConnection;51;0;45;0
WireConnection;51;1;69;0
WireConnection;27;0;29;0
WireConnection;27;4;55;0
WireConnection;27;2;24;0
WireConnection;27;3;26;0
WireConnection;23;0;1;0
WireConnection;44;0;46;0
WireConnection;44;4;51;0
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
WireConnection;19;0;17;0
WireConnection;43;0;44;0
WireConnection;30;0;21;0
WireConnection;30;1;31;0
WireConnection;30;2;28;0
WireConnection;50;0;30;0
WireConnection;50;1;49;0
WireConnection;50;2;43;0
WireConnection;0;2;50;0
WireConnection;0;11;20;0
ASEEND*/
//CHKSM=CD0EB8C0EFDFE6C504C5CA079F66DD66D8D39162