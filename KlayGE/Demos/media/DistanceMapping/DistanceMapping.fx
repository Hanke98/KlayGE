float4x4 worldviewproj : WORLDVIEWPROJECTION;
float4 lightPos;
float4 eyePos;

struct VS_INPUT
{
	float4 pos			: POSITION;
	float2 texcoord0	: TEXCOORD0;
	float3 T			: TANGENT;	// in object space
	float3 B			: BINORMAL;	// in object space
};

struct VS_OUTPUT
{
	float4 pos			: POSITION;
	float3 texcoord0	: TEXCOORD0;

	float3 L			: TEXCOORD1;	// in tangent space
	float3 V			: TEXCOORD2;	// in tangent space
};

VS_OUTPUT DistanceMappingVS(VS_INPUT input,
						uniform float4x4 worldviewproj,
						uniform float4 lightPos,
						uniform float4 eyePos)
{
	VS_OUTPUT output;

	output.pos = mul(input.pos, worldviewproj);
	output.texcoord0 = float3(input.texcoord0, 1);

	float3x3 matObjToTangentSpace;
	matObjToTangentSpace[0] = input.T;
	matObjToTangentSpace[1] = input.B;
	matObjToTangentSpace[2] = cross(input.T, input.B);

	float3 vLight = lightPos.xyz - input.pos;
	float3 vView = eyePos.xyz - input.pos;

	float3 vTanLight = mul(vLight, matObjToTangentSpace);
	float3 vTanView = mul(vView, matObjToTangentSpace);

	output.L = vTanLight;
	output.V = vTanView;

	return output;
}


sampler2D diffuseMapSampler;
sampler2D normalMapSampler;
sampler3D distanceMapSampler;
samplerCUBE normalizerMapSampler;

float3 NormalizeByCube(float3 v)
{
	return texCUBE(normalizerMapSampler, v).rgb * 2 - 1;
}

float4 DistanceMappingPS(float3 texCoord0	: TEXCOORD0,
						float3 L		: TEXCOORD1,
						float3 V		: TEXCOORD2,

					uniform sampler2D diffuseMap,
					uniform sampler2D normalMap,
					uniform sampler3D distanceMap,
					uniform samplerCUBE normalizerMap) : COLOR
{
	float3 view = NormalizeByCube(V) * float3(1, 1, 16) * -0.06;

	float3 texUV = texCoord0;
	for (int i = 0; i < 8; ++ i)
	{
		float dist = tex3D(distanceMap, texUV).r;
		texUV += view * dist;
	}

	float2 dx = ddx(texCoord0.xy);
	float2 dy = ddy(texCoord0.xy);

	float3 diffuse = tex2D(diffuseMap, texUV.xy, dx, dy).rgb;

	float3 bumpNormal = NormalizeByCube(tex2D(normalMap, texUV.xy, dx, dy).rgb * 2 - 1);
	float3 lightVec = NormalizeByCube(L);
	float diffuseFactor = dot(lightVec, bumpNormal);

	return float4(diffuse * diffuseFactor, 1);
}

float4 DistanceMappingPS_20(float3 texCoord0	: TEXCOORD0,
						float3 L		: TEXCOORD1,
						float3 V		: TEXCOORD2,

					uniform sampler2D diffuseMap,
					uniform sampler2D normalMap,
					uniform sampler3D distanceMap,
					uniform samplerCUBE normalizerMap) : COLOR
{
	float3 view = NormalizeByCube(V) * float3(1, 1, 16) * -0.06;

	float3 texUV = texCoord0;
	for (int i = 0; i < 2; ++ i)
	{
		float dist = tex3D(distanceMap, texUV).r;
		texUV += view * dist;
	}

	float3 diffuse = tex2D(diffuseMap, texUV.xy);

	float3 bumpNormal = NormalizeByCube(tex2D(normalMap, texUV.xy).rgb * 2 - 1);
	float3 lightVec = NormalizeByCube(L);
	float diffuseFactor = dot(lightVec, bumpNormal);

	return float4(diffuse * diffuseFactor, 1);
}

technique DistanceMapping30
{
	pass p0
	{
		VertexShader = compile vs_3_0 DistanceMappingVS(worldviewproj, lightPos, eyePos);
		PixelShader = compile ps_3_0 DistanceMappingPS(diffuseMapSampler,
										normalMapSampler, distanceMapSampler,
										normalizerMapSampler);
	}
}

technique DistanceMapping2a
{
	pass p0
	{
		VertexShader = compile vs_1_1 DistanceMappingVS(worldviewproj, lightPos, eyePos);
		PixelShader = compile ps_2_a DistanceMappingPS(diffuseMapSampler,
										normalMapSampler, distanceMapSampler,
										normalizerMapSampler);
	}
}

technique DistanceMapping20
{
	pass p0
	{
		VertexShader = compile vs_1_1 DistanceMappingVS(worldviewproj, lightPos, eyePos);
		PixelShader = compile ps_2_0 DistanceMappingPS_20(diffuseMapSampler,
										normalMapSampler, distanceMapSampler,
										normalizerMapSampler);
	}
}
