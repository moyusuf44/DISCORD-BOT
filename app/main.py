import os
import discord
import boto3

from discord import app_commands
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

# CONFIG


TOKEN = os.getenv("DISCORD_BOT_TOKEN")
REGION = "eu-north-1"

ECS_CLUSTER = "discord-bot-cluster"
ECS_SERVICE = "discord-bot-service"
SQS_QUEUE_URL = "https://sqs.eu-north-1.amazonaws.com/592587463331/discord-bot-queue"
DYNAMODB_TABLE = "discord-table"
GUILD_ID = 1539149508590698587

# AWS

ecs = boto3.client("ecs", region_name=REGION)
sqs = boto3.client("sqs", region_name=REGION)
dynamodb = boto3.resource("dynamodb", region_name=REGION)

table = dynamodb.Table(DYNAMODB_TABLE)

# DISCORD

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(
    command_prefix="!",
    intents=intents
)

@bot.event
async def on_ready():

    guild = discord.Object(id=GUILD_ID)

    bot.tree.copy_global_to(guild=guild)
    synced = await bot.tree.sync(guild=guild)

    print(f"Logged in as {bot.user}")
    print(f"Synced {len(synced)} commands")

# PING

@bot.tree.command(
    name="ping",
    description="Check if the bot is online."
)
async def ping(interaction: discord.Interaction):

    await interaction.response.send_message(
        "🏓 Pong!"
    )

# HEALTH

@bot.tree.command(
    name="health",
    description="Check bot health."
)
async def health(interaction: discord.Interaction):

    await interaction.response.send_message(
        "🟢 Bot is healthy."
    )

# ECS STATUS

@bot.tree.command(
    name="status",
    description="Check ECS service status."
)
async def status(interaction: discord.Interaction):

    try:
        response = ecs.describe_services(
            cluster=ECS_CLUSTER,
            services=[ECS_SERVICE]
        )

        service = response["services"][0]

        await interaction.response.send_message(
            f"🟢 ECS: {service['status']}\n"
            f"Running: {service['runningCount']}\n"
            f"Desired: {service['desiredCount']}"
        )

    except Exception as error:

        print(f"ECS ERROR: {error}")

        await interaction.response.send_message(
            f"❌ ECS error:\n`{error}`"
        )

# SQS TASK

@bot.tree.command(
    name="task",
    description="Send a task to SQS."
)
@app_commands.describe(
    message="Task to send"
)
async def task(
    interaction: discord.Interaction,
    message: str
):

    sqs.send_message(
        QueueUrl=SQS_QUEUE_URL,
        MessageBody=message
    )

    await interaction.response.send_message(
        f"📨 Task queued: `{message}`"
    )

# DYNAMODB HISTORY

@bot.tree.command(
    name="history",
    description="Save an activity to DynamoDB."
)
@app_commands.describe(
    message="Activity to save"
)
async def history(
    interaction: discord.Interaction,
    message: str
):

    table.put_item(
        Item={
            "id": str(interaction.id),
            "user": str(interaction.user),
            "message": message
        }
    )

    await interaction.response.send_message(
        "💾 Activity saved to DynamoDB."
    )

bot.run(TOKEN)