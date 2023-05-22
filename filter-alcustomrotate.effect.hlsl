//Thanks for this site, I got a idea of rotation.
//most of codes are from this site.
//https://gamedev.stackexchange.com/questions/103002/how-to-rotate-a-3d-instance-using-an-hlsl-shader
//Thanks for this site for matrix calculations
//https://www.redcrab-software.com/en/Calculator/4x4/Matrix/Rotation-XYZ

// OBS-specific syntax adaptation to HLSL standard to avoid errors
//  reported by the code editor
#define SamplerState sampler_state
#define Texture2D texture2d


// Uniform variables set by OBS (required)
uniform float4x4 ViewProj; // View-projection matrix used in the vertex shader
uniform Texture2D image;   // Texture containing the source picture
// General properties
uniform int width;
uniform int height;
uniform float rotatex;
uniform float rotatey;
uniform float rotatez;
uniform float positionx;
uniform float positiony;
uniform float positionz;
uniform float wrotatex;
uniform float wrotatey;
uniform float wrotatez;
uniform float wpositionx;
uniform float wpositiony;
uniform float wpositionz;


// Interpolation method and wrap mode for sampling a texture
SamplerState linear_clamp
{
    Filter    = Linear;     // Anisotropy / Point / Linear
    AddressU  = Clamp;      // Wrap / Clamp / Mirror / Border / MirrorOnce
    AddressV  = Clamp;      // Wrap / Clamp / Mirror / Border / MirrorOnce
    BorderColor = 00000000; // Used only with Border edges (optional)
};


// Data type of the input of the vertex shader
struct vertex_data
{
    float4 pos : POSITION;  // Homogeneous space coordinates XYZW
    float2 uv  : TEXCOORD0; // UV coordinates in the source picture
};
struct pixel_data
{
    float4 pos : POSITION;  // Homogeneous space coordinates XYZW
    float2 uv  : TEXCOORD0; // UV coordinates in the source picture
};


// Vertex shader used to compute position of rendered pixels and pass UV
pixel_data vertex_shader_alcustomrotate(vertex_data vertex)
{
    pixel_data pixel;
    //pixel.pos = mul(float4(vertex.pos.xyz, 1.0), ViewProj);
    //pixel.uv  = vertex.uv;
	// Change the position vector to be 4 units for proper matrix calculations.
	vertex.pos.w = 1.0f;


	matrix <float, 4, 4> translation =
	{
		1.0f, 0.0f, 0.0f, 0.0f,
		0.0f, 1.0f, 0.0f, 0.0f,
		0.0f, 0.0f, 1.0f, 0.0f,
		positionx, positiony, positionz, 1.0f
	};
	matrix <float, 4, 4> wtranslation =
	{
		1.0f, 0.0f, 0.0f, 0.0f,
		0.0f, 1.0f, 0.0f, 0.0f,
		0.0f, 0.0f, 1.0f, 0.0f,
		wpositionx, wpositiony, wpositionz, 1.0f
	};
    /*
	matrix <float, 4, 4> rotationAroundY = {
		cos(rotatey), 0.0f, -sin(rotatey), 0.0f,
		0.0f,         1.0f, 0.0f,          0.0f,
		sin(rotatey), 0.0f, cos(rotatey),  0.0f,
		0.0f,         0.0f, 0.0f,          1.0f   
	};
	
	matrix <float, 4, 4> rotationAroundX = {
		1.0f, 0.0f,         0.0f,          0.0f,
		0.0f, cos(rotatex), -sin(rotatex), 0.0f,
		0.0f, sin(rotatex), cos(rotatex),  0.0f,
		0.0f, 0.0f,         0.0f,          1.0f
	};
	
	matrix <float, 4, 4> rotationAroundZ = {
		cos(rotatez), -sin(rotatez),0.0f, 0.0f,
		sin(rotatez), cos(rotatez), 0.0f, 0.0f,
		0.0f,         0.0f,         1.0f, 0.0f,
		0.0f,         0.0f,         0.0f, 1.0f
	};
	*/
	
	matrix <float, 4, 4> rotationAroundXYZ = {
		dot(cos(rotatez),cos(rotatey)), dot(dot(cos(rotatez),sin(rotatey)),sin(rotatex)) - dot(sin(rotatez),cos(rotatex)), dot(dot(cos(rotatez),sin(rotatey)),cos(rotatex)) + dot(sin(rotatez),sin(rotatex)), 0.0f,
		dot(sin(rotatez),cos(rotatey)), dot(dot(sin(rotatez),sin(rotatey)),sin(rotatex)) + dot(cos(rotatez),cos(rotatex)), dot(dot(sin(rotatez),sin(rotatey)),cos(rotatex)) - dot(cos(rotatez),sin(rotatex)), 0.0f,
		-sin(rotatey), dot(cos(rotatey),sin(rotatex)), dot(cos(rotatey),cos(rotatex)), 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f
	};


	matrix <float, 4, 4> composition;
	
	matrix <float, 4, 4> worldMatrix ={
		dot(cos(wrotatez),cos(wrotatey)), dot(dot(cos(wrotatez),sin(wrotatey)),sin(wrotatex)) - dot(sin(wrotatez),cos(wrotatex)), dot(dot(cos(wrotatez),sin(wrotatey)),cos(wrotatex)) + dot(sin(wrotatez),sin(wrotatex)), 0.0f,
		dot(sin(wrotatez),cos(wrotatey)), dot(dot(sin(wrotatez),sin(wrotatey)),sin(wrotatex)) + dot(cos(wrotatez),cos(wrotatex)), dot(dot(sin(wrotatez),sin(wrotatey)),cos(wrotatex)) - dot(cos(wrotatez),sin(wrotatex)), 0.0f,
		-sin(wrotatey), dot(cos(wrotatey),sin(wrotatex)), dot(cos(wrotatey),cos(wrotatex)), 0.0f,
		0.0f, 0.0f, 0.0f, 1.0f
	};

	//i compose together the rotation around y and the translation, the order is important!
	composition = mul(rotationAroundXYZ, translation);
	//i apply the transformation to the vertex input.position
	pixel.pos = mul(vertex.pos, composition);
	//pixel.pos = mul(pixel.pos, rotationAroundX);
	//pixel.pos = mul(pixel.pos, rotationAroundZ);

	composition = mul(worldMatrix, wtranslation);
	// Calculate the position of the vertex against the world, view, and projection matrices.
	pixel.pos = mul(pixel.pos, ViewProj);
	pixel.pos = mul(pixel.pos, composition);
	//pixel.pos = mul(pixel.pos, projectionMatrix);

	// Store the texture coordinates for the pixel shader.
	pixel.uv = vertex.uv;

	// Calculate the normal vector against the world matrix only.
	//pixel.normal = mul(vertex.normal, ViewProj);
	
	// Normalize the normal vector.
	//pixel.normal = normalize(pixel.normal);
    return pixel;
}

// Pixel shader used to compute an RGBA color at a given pixel position
float4 pixel_shader_alcustomrotate(pixel_data pixel) : TARGET
{
    float4 source_sample = image.Sample(linear_clamp, pixel.uv);

    return source_sample;
}


technique Draw
{
    pass
    {
        vertex_shader = vertex_shader_alcustomrotate(vertex);
        pixel_shader  = pixel_shader_alcustomrotate(pixel);
    }
}
