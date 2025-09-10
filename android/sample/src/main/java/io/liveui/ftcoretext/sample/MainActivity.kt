package io.liveui.ftcoretext.sample

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val items = buildExamples()
        val recycler = findViewById<RecyclerView>(R.id.recycler)
        recycler.layoutManager = LinearLayoutManager(this)
        recycler.addItemDecoration(DividerItemDecoration(this, DividerItemDecoration.VERTICAL))
        recycler.adapter = ExampleAdapter(items) { example ->
            val i = Intent(this, DetailActivity::class.java)
            i.putExtra("title", example.title)
            i.putExtra("subtitle", example.subtitle)
            i.putExtra("text", example.text)
            startActivity(i)
        }
    }
}

data class Example(val title: String, val subtitle: String, val text: String)

class ExampleAdapter(
    private val items: List<Example>,
    private val onClick: (Example) -> Unit
) : RecyclerView.Adapter<ExampleVH>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ExampleVH {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_example, parent, false)
        return ExampleVH(v)
    }
    override fun onBindViewHolder(holder: ExampleVH, position: Int) = holder.bind(items[position], onClick)
    override fun getItemCount(): Int = items.size
}

class ExampleVH(itemView: View) : RecyclerView.ViewHolder(itemView) {
    private val title = itemView.findViewById<TextView>(R.id.title)
    private val subtitle = itemView.findViewById<TextView>(R.id.subtitle)
    fun bind(ex: Example, onClick: (Example) -> Unit) {
        title.text = ex.title
        subtitle.text = ex.subtitle
        itemView.setOnClickListener { onClick(ex) }
    }
}

private fun MainActivity.buildExamples(): List<Example> {
    val list = mutableListOf<Example>()
    list += Example(
        "Basic + Link",
        "Default styles with a tappable link",
        "Welcome to <_link>https://github.com/LiveUI/FTCoreText|FTCoreText</_link> demo."
    )
    list += Example(
        "Heading + Paragraph",
        "Custom heading and paragraph",
        "<_h1>FTCoreText</_h1>\n<_paragraph>This paragraph uses the built-in paragraph tag with custom inset and alignment.</_paragraph>"
    )
    list += Example(
        "Custom Tag Rename",
        "Map default paragraph to <p> tag",
        "<p>This uses a custom tag name after renaming default paragraph.</p>"
    )
    list += Example(
        "Bulleted List",
        "<_bullet> items with hanging indent",
        listOf(
            "<_bullet>First bullet item wraps to next line to demonstrate hanging indent.</_bullet>",
            "<_bullet>Second bullet item with a link to <_link>https://apple.com|Apple</_link>.</_bullet>",
            "<_bullet>Third bullet item.</_bullet>",
            "<_bullet>Another bullet item.</_bullet>",
            "<_bullet>Another bullet item.</_bullet>",
            "<_bullet>Last bullet item.</_bullet>"
        ).joinToString("\n")
    )
    list += Example(
        "Image Float (giraffe)",
        "<_image>giraffe</_image> with drop cap and padding",
        "<_image>giraffe</_image>" +
            "<_paragraph>" +
            "<_dropcap>T</_dropcap>his text should wrap next to the image with padding. " +
            List(10) { "More content continues to demonstrate wrapping. " }.joinToString(separator = "") +
            "</_paragraph>"
    )
    list += Example(
        "Monospace Code",
        "Custom <_code> tag",
        "Inline <_code>val answer = 42</_code> sample."
    )
    list += Example(
        "Suggested Size",
        "Long text resized to fit width",
        "<_paragraph>" + List(20) { "Lorem ipsum dolor sit amet, " }.joinToString(separator = "") + "</_paragraph>"
    )

    // Dedicated Base64 example if present in shared assets
    runCatching {
        val primary = "Texts/Base64Example.txt"
        val fallback = "Base64Example.txt"
        val path = when {
            assetsExists(primary) -> primary
            assetsExists(fallback) -> fallback
            else -> null
        }
        path?.let {
            val content = assets.open(it).bufferedReader().use { r -> r.readText() }
            list += Example("Base64 Example", "Inline Base64 image rendered in text", content)
        }
    }
    // load any .txt assets under shared Texts
    try {
        val dir = "Texts"
        val names = assets.list(dir)?.filter { it.endsWith(".txt", ignoreCase = true) && it != "Base64Example.txt" } ?: emptyList()
        names.sorted().forEach { file ->
            val path = "$dir/$file"
            val content = assets.open(path).bufferedReader().use { it.readText() }
            list += Example("Resource: ${file.removeSuffix(".txt")}", "From assets/$path", content)
        }
    } catch (_: Throwable) { }

    return list
}

private fun android.app.Activity.assetsExists(path: String): Boolean = try {
    assets.open(path).close(); true
} catch (_: Throwable) { false }
