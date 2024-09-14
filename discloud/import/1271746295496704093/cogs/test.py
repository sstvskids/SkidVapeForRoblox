import discord
from discord.ext import commands

class Test(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

        @commands.Cog.listener()
        async def on_ready(self):
            print("cog.test is online!")

@commands.command()
async def ping(self, ctx):
    ping_embed = discord.Embed(title="Ping", description="Latency in ms", color=discord.Color.red())
    ping_embed.add_field(name=f"{self.bot.user.name}'s Latency (ms): ", value=f"{round(self.bot.latency * 1000)}ms. ", inline=False)
    ping_embed.set_footer(text=f"(Requested by {ctx.author.name}.)", icon_url=ctx.author.avatar)
    await ctx.send(embed=ping_embed)

async def setup(bot):
    await bot.add_cog(Test(bot))

load_dotenv()
bot = DiscordBot()
bot.run(os.getenv("TOKEN"))