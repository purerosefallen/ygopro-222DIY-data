--虚幻法师的神秘预言者
function c66913804.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x371),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--drawandremove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66913804,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,66913804)
	e1:SetCondition(c66913804.drcon)
	e1:SetTarget(c66913804.target)
	e1:SetOperation(c66913804.activate)
	c:RegisterEffect(e1)
	--fimbulvinter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66913804,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,66913804+EFFECT_COUNT_CODE_DUEL)
	e2:SetCountLimit(1,66913804)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c66913804.con)
	e2:SetTarget(c66913804.tg)
	e2:SetOperation(c66913804.op)
	c:RegisterEffect(e2)
end
function c66913804.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,2)
end
function c66913804.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)   
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	
end
function c66913804.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c66913804.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=15
end

function c66913804.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c66913804.op(e,tp,eg,ep,ev,re,r,rp)
	--damage
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(1-tp)
	e1:SetTarget(c66913804.damtg)
	e1:SetOperation(c66913804.damop)
	e1:SetCondition(c66913804.cons)
	Duel.RegisterEffect(e1,tp)
end
function c66913804.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	return true
end
function c66913804.cons(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c66913804.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,66913804)

	local lp=Duel.GetLP(e:GetLabel())
	if lp>1500  then 
		lp=lp-1500
	else 
		lp=0 
	end

	Duel.SetLP(e:GetLabel(),lp)
end

