
void GetMainLight_float(out float3 Direction, out float3 Color, out float Intensity)
{
	#if SHADERGRAPH_PREVIEW
		Direction = float3(0.5, 0.5, 0);
		Color = 1;
		Intensity = 1;
	#else
		Light light = GetMainLight();
		Direction = light.direction;
		Color = light.color;
		Intensity = light.distanceAttenuation;
	#endif
}