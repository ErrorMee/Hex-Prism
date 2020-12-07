using UnityEngine;
using System.Collections;
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]

public class PrismMesh : MonoBehaviour
{
	[SerializeField]
	[Range(3,32)]
	private uint m_Edges = 3;
	public uint EdgeNumber
	{
		get { return m_Edges; }
		set { m_Edges = (uint)Mathf.Clamp(value, 3, 32); UpdateMesh(); }
	}

	[SerializeField]
	[Range(0, 1)]
	private float m_Radius = 0.5f;

	[SerializeField]
	[Range(0, 16)]
	private uint m_Floors = 1;

	[SerializeField]
	[Range(0, 16)]
	private float m_FloorHeight = 1;

	private Vector3[] vertices;

	private Mesh mesh;

	private void Awake()
    {
		Generate();
	}

	private void Generate()
	{
		GetComponent<MeshFilter>().mesh = mesh = new Mesh();
		UpdateMesh();
	}

	private void UpdateMesh()
	{
		if (mesh == null)
		{
			return;
		}
		mesh.name = "Prism" + m_Edges;

		vertices = new Vector3[m_Edges + 1];
		Vector2[] uvs = new Vector2[vertices.Length];
		Vector4[] tangents = new Vector4[vertices.Length];
		Vector4 tangent = new Vector4(1f, 0f, 0f, -1f);

		Vector3 centerVertex = Vector3.zero;
		Vector2 centerUV = Vector2.one * 0.5f;

		vertices[0] = centerVertex;
		uvs[0] = centerUV;
		tangents[0] = tangent;

		for (uint i = 0; i < m_Edges; i++)
		{
			float angle = Mathf.PI * 2 / m_Edges * i;

			float sin = Mathf.Sin(angle);
			float cos = Mathf.Cos(angle);

			uint index = i + 1;
			vertices[index] = new Vector3(sin * m_Radius, 0, cos * m_Radius);
			uvs[index] = new Vector2(sin, cos);
			tangents[index] = tangent;
		}

		mesh.vertices = vertices;
		mesh.uv = uvs;
		mesh.tangents = tangents;

		int[] triangles = new int[m_Edges * 3];
		for (int ti = 0; ti < m_Edges; ti++)
		{
			triangles[ti * 3 + 0] = 0;
			triangles[ti * 3 + 1] = ti + 1;
			if (ti + 2 >= mesh.vertices.Length)
			{
				triangles[ti * 3 + 2] = 1;
			}
			else
			{
				triangles[ti * 3 + 2] = ti + 2;
			}
		}
		mesh.triangles = triangles;
		//mesh.colors = [];顶点色
		mesh.RecalculateNormals();
	}

	private void OnDrawGizmos()
	{
		if (vertices == null)
			return;
		Gizmos.color = Color.black;
		for (int i = 0; i < vertices.Length; i++)
		{
			Gizmos.DrawSphere(vertices[i], 0.1f);
		}
	}
}
