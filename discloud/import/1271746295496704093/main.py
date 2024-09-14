import discord
from discord.ext import commands, tasks
import os
import hashlib
import requests
import json
from dotenv import load_dotenv
import base64
from itertools import cycle

COMMIT_HASH_FILE = 'commit_hash.json'
bot = commands.Bot(command_prefix=".", intents=discord.Intents.all())
bot_statuses = cycle(["maxNIGGERtech in his cage", "Stav ;)", "you paste from Skid-Vape 🤑", "@stavexploitz"])
CONFIG_LOG = 1264042786974597150

@tasks.loop(seconds=5)
async def change_bot_status():
    await bot.change_presence(status=discord.Status.dnd, activity=discord.Game(next(bot_statuses)))

@bot.event
async def on_ready():
    print("Bot is ready!")
    change_bot_status.start()
    try:
        synced_commands = await bot.tree.sync()
        print(f"Synced {len(synced_commands)} commands.")
    except Exception as e:
        print("An error with syncing application commands has occurred: ", e)

async def check_level(interaction: discord.Interaction) -> int:
    level = 0  # Default level

    if "cool kids" in [role.name for role in interaction.user.roles]:
        level = 1
    elif "hottie" in [role.name for role in interaction.user.roles]:
        level = 2
    
    return level

# Slash Command for Adding to Whitelist
@bot.tree.command(name="add_to_whitelist", description="Add or update a user in the whitelist")
@commands.has_role("cool kids")
async def add_to_whitelist(
    interaction: discord.Interaction,
    discord_user_id: str,
    roblox_user_name: str,
    roblox_user_id: str,
    attackable: str,
    tag_text: str,
    tag_color: str
):
    # Validate the 'attackable' value
    if attackable.lower() not in ['true', 'false']:
        await interaction.response.send_message("Invalid value for 'attackable'. Please use 'true' or 'false'.", ephemeral=True)
        return

    # Process the inputs
    attackable = attackable.lower() == 'true'
    tag_color = list(map(int, tag_color.split(',')))
    data = roblox_user_name + roblox_user_id
    roblox_hash = hashlib.sha512(data.encode()).hexdigest()
    level = await check_level(interaction)

    # Update GitHub repository
    github_token = os.getenv("GITHUB_TOKEN")
    repo_name = "sstvskids/whitelists"           ## wl repo
    file_path = "PlayerWhitelist.json"
    branch_name = "main"

    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json"
    }

    # Fetch the existing file
    response = requests.get(f"https://api.github.com/repos/{repo_name}/contents/{file_path}?ref={branch_name}", headers=headers)
    if response.status_code != 200:
        await interaction.response.send_message("Failed to fetch the JSON file from GitHub.", ephemeral=True)
        return

    content = response.json()
    file_content = requests.get(content['download_url']).text
    data = json.loads(file_content)

    # Update or add the whitelist entry
    if discord_user_id in data["WhitelistedUsers"]:
        # Update existing entry
        data["WhitelistedUsers"][discord_user_id].update({
            "hash": roblox_hash,
            "attackable": attackable,
            "level": level,
            "tags": [
                {
                    "text": tag_text,
                    "color": tag_color
                }
            ]
        })
        message = f"Updated whitelisted user {discord_user_id}!"
    else:
        # Add new entry
        data["WhitelistedUsers"][discord_user_id] = {
            "hash": roblox_hash,
            "attackable": attackable,
            "level": level,
            "tags": [
                {
                    "text": tag_text,
                    "color": tag_color
                }
            ]
        }
        message = f"Added whitelisted user {discord_user_id}"

    # Prepare the updated content for GitHub
    updated_content = json.dumps(data, indent=4).encode('utf-8')

    update_data = {
        "message": message,
        "content": base64.b64encode(updated_content).decode('utf-8'),
        "sha": content["sha"],
        "branch": branch_name
    }

    # Update the file on GitHub
    update_response = requests.put(f"https://api.github.com/repos/{repo_name}/contents/{file_path}", headers=headers, data=json.dumps(update_data))
    if update_response.status_code == 200:
        await interaction.response.send_message("Whitelist updated successfully.", ephemeral=True)
    else:
        await interaction.response.send_message("Failed to update the JSON file on GitHub.", ephemeral=True)

# Slash Command for Removing from Whitelist
@bot.tree.command(name="unwhitelist", description="Remove a user from the whitelist")
@commands.is_owner()
async def unwhitelist(interaction: discord.Interaction, discord_user_id: str):
    # Update GitHub repository
    github_token = os.getenv("GITHUB_TOKEN")
    repo_name = "sstvskids/whitelists"                  ## wl repo name
    file_path = "PlayerWhitelist.json"
    branch_name = "main"

    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json"
    }

    # Fetch the existing file
    response = requests.get(f"https://api.github.com/repos/{repo_name}/contents/{file_path}?ref={branch_name}", headers=headers)
    if response.status_code != 200:
        await interaction.response.send_message("Failed to fetch the JSON file from GitHub.", ephemeral=True)
        return

    content = response.json()
    file_content = requests.get(content['download_url']).text
    data = json.loads(file_content)

    # Remove the user from the whitelist if they exist
    if discord_user_id in data["WhitelistedUsers"]:
        del data["WhitelistedUsers"][discord_user_id]
        message = f"Removed whitelisted user {discord_user_id}"
    else:
        await interaction.response.send_message(f"No whitelist entry found for user ID {discord_user_id}.", ephemeral=True)
        return

    # Prepare the updated content for GitHub
    updated_content = json.dumps(data, indent=4).encode('utf-8')

    update_data = {
        "message": message,
        "content": base64.b64encode(updated_content).decode('utf-8'),
        "sha": content["sha"],
        "branch": branch_name
    }

    # Update the file on GitHub
    update_response = requests.put(f"https://api.github.com/repos/{repo_name}/contents/{file_path}", headers=headers, data=json.dumps(update_data))
    if update_response.status_code == 200:
        await interaction.response.send_message("User removed from the whitelist.", ephemeral=True)
    else:
        await interaction.response.send_message("Failed to update the JSON file on GitHub.", ephemeral=True)

@bot.tree.command(name="whitelistedusers", description="Lists the Discord IDs and tag texts of the whitelisted users")
async def whitelistedusers(interaction: discord.Interaction):
    github_token = os.getenv("GITHUB_TOKEN")
    repo_name = "sstvskids/whitelists"
    file_path = "PlayerWhitelist.json"
    branch_name = "main"

    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json"
    }

    response = requests.get(f"https://api.github.com/repos/{repo_name}/contents/{file_path}?ref={branch_name}", headers=headers)
    if response.status_code != 200:
        await interaction.response.send_message("Failed to fetch the JSON file from GitHub.", ephemeral=True)
        return

    content = response.json()
    file_content = requests.get(content['download_url']).text
    data = json.loads(file_content)

    whitelisted_info = []
    for user_id, user_data in data["WhitelistedUsers"].items():
        tags = ", ".join([tag["text"] for tag in user_data["tags"]])
        whitelisted_info.append((user_id, tags))

    whitelisted_message = "\n".join([f"{user_id}: {tags}" for user_id, tags in whitelisted_info])

    await interaction.response.send_message(f"Whitelisted Users:\n{whitelisted_message}", ephemeral=True)

async def Load():
    for filename in os.listdir("./cogs"):
        if filename.endswith(".py"):
            await bot.load_extension(f"cogs.{filename[:-3]}")

async def main():
    async with bot:
        await Load()
        await bot.start(os.getenv("TOKEN"))

@bot.tree.command(name="credits", description="Gives credits to all those involved ;)")
async def credits(interaction: discord.Interaction):
    embeded_msg = discord.Embed(title="hi ;)", description="thanks for using skid-ware :)", colour=discord.Color.red())
    embeded_msg.set_thumbnail(url=interaction.user.avatar.url)
    embeded_msg.add_field(name="Made possible by:", value="stav, sk1dded, nebula :iknowwhereyoulive:, relic (chang3d), qwertyui", inline=False)
    embeded_msg.add_field(name="hi ;) - stav", value="", inline=False)
    await interaction.response.send_message(embed=embeded_msg)

@bot.tree.command(name="ping", description="Latency analysis")
async def ping(interaction: discord.Interaction):
    ping_embed = discord.Embed(title="Ping", description="Latency in ms", color=discord.Color.red())
    ping_embed.add_field(name=f"{bot.user.name}'s Latency (ms):", value=f"{round(bot.latency * 1000)}ms.", inline=False)
    ping_embed.set_footer(text=f"(Requested by {interaction.user.name})", icon_url=interaction.user.avatar.url)
    await interaction.response.send_message(embed=ping_embed)

# Modal for Sending a Whitelist Request
class SendWhitelistRequestModal(discord.ui.Modal, title="Send a Whitelist Request"):
    def __init__(self, bot: commands.Bot):
        super().__init__()
        self.bot = bot

    roblox_hash = discord.ui.TextInput(label="User's Hash", placeholder="Get your hash with the **/hash_a_account** command", required=True, style=discord.TextStyle.long)
    discord_user_id = discord.ui.TextInput(label="Discord ID", placeholder="e.g., 9293812310293", required=True, style=discord.TextStyle.short)
    discord_user_name = discord.ui.TextInput(label="Discord Username", placeholder="e.g., ._stav", required=True, style=discord.TextStyle.short)

    async def on_submit(self, interaction: discord.Interaction):
        owner_id = 744133099994087532                                          # Replace with the actual Discord user ID of the bot owner
        owner = await self.bot.fetch_user(owner_id)

        embed = discord.Embed(title="Support Request", description="A new Support request has been submitted.", color=discord.Color.green())
        embed.add_field(name="What do you need help with?", value=self.roblox_hash.value, inline=False)
        embed.add_field(name="Discord ID", value=self.discord_user_id.value, inline=False)
        embed.add_field(name="Discord Username", value=self.discord_user_name.value, inline=False)
        embed.set_image(url=interaction.guild.icon.url)

        await owner.send(embed=embed)
        await interaction.response.send_message("Support request sent. ;)", ephemeral=True)

# Slash Command for Sending a Whitelist Request
@bot.tree.command(name="send_help_request", description="Sends a Support/Help request to Stav")
@commands.cooldown(1, 20, commands.BucketType.user)
async def send_whitelist_request(interaction: discord.Interaction):
    modal = SendWhitelistRequestModal(bot)  # Pass the bot instance
    await interaction.response.send_modal(modal)

@send_whitelist_request.error
async def sendwhitelistreq_error(interaction: discord.Interaction, error: commands.CommandError):
    if isinstance(error, commands.CommandOnCooldown):
        await interaction.response.send_message(f"This command is on cooldown. Please try again after {int(error.retry_after)} seconds.", ephemeral=True)
    else:
        await interaction.response.send_message("An error occurred while processing the command.", ephemeral=True)

load_dotenv()
bot.run(os.getenv("TOKEN"))
