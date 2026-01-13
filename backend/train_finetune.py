"""
Simple fine-tuning script using Hugging Face Trainer.
Usage:
  python train_finetune.py --train_file ../data/labeled_samples.jsonl --output_dir models/emotion-finetuned --model_name distilroberta-base
"""
import argparse
import json
from datasets import load_dataset, ClassLabel, DatasetDict
from transformers import AutoTokenizer, AutoModelForSequenceClassification, TrainingArguments, Trainer
import numpy as np
import os

EMOTION_LABELS = [
    "Joy/Happy",
    "Calm/Relaxed",
    "Sad/Depressed",
    "Angry/Irritated",
    "Fearful/Anxious",
    "Disgusted/Envious",
    "Surprised/Inspired",
    "Anticipation/Optimistic",
    "Neutral/Mixed"
]


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--train_file", required=True)
    p.add_argument("--output_dir", required=True)
    p.add_argument("--model_name", default="distilroberta-base")
    p.add_argument("--epochs", type=int, default=3)
    p.add_argument("--batch_size", type=int, default=16)
    return p.parse_args()


def main():
    args = parse_args()
    # Load dataset from JSONL
    raw = load_dataset("json", data_files={"train": args.train_file})
    # Map labels to integers
    label2id = {l: i for i, l in enumerate(EMOTION_LABELS)}

    def preprocess(example):
        example["label_id"] = label2id.get(example["label"], label2id["Neutral/Mixed"])
        return example

    raw = raw.map(preprocess)
    tokenizer = AutoTokenizer.from_pretrained(args.model_name)

    def tokenize(batch):
        return tokenizer(batch["text"], padding=True, truncation=True, max_length=128)

    tokenized = raw.map(tokenize, batched=True)

    model = AutoModelForSequenceClassification.from_pretrained(args.model_name, num_labels=len(EMOTION_LABELS))

    train_args = TrainingArguments(
        output_dir=args.output_dir,
        num_train_epochs=args.epochs,
        per_device_train_batch_size=args.batch_size,
        save_total_limit=2,
        evaluation_strategy="no",
        logging_steps=10,
    )

    def compute_metrics(eval_pred):
        logits, labels = eval_pred
        preds = np.argmax(logits, axis=-1)
        acc = (preds == labels).mean()
        return {"accuracy": acc}

    trainer = Trainer(
        model=model,
        args=train_args,
        train_dataset=tokenized["train"],
        tokenizer=tokenizer,
        compute_metrics=compute_metrics
    )

    trainer.train()
    trainer.save_model(args.output_dir)
    print("Saved fine-tuned model to:", args.output_dir)


if __name__ == "__main__":
    main()
