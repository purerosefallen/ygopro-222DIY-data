--音语—绝响之钢琴
function c22600019.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x260),2)
	c:EnableReviveLimit()

	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)

	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22600019.atkcon)
	e1:SetOperation(c22600019.atkop)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22600019.recon)
	e2:SetTarget(c22600019.retg)
	e2:SetOperation(c22600019.reop)
	c:RegisterEffect(e2)

	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c22600019.efilter)
	c:RegisterEffect(e3)

	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c22600019.retg2)
	e4:SetOperation(c22600019.reop2)
	c:RegisterEffect(e4)
end

function c22600019.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and (x-ct)>=2
end

function c22600019.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ct*100)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

function c22600019.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>=4
end

function c22600019.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>=4 and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600019,1))
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_REMOVED,4,4,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end

function c22600019.reop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if sg:GetCount()>0 then
		local sg1=sg:Select(tp,1,1,nil)
		Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c22600019.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>=6
end

function c22600019.filter(c)
	return c:IsSetCard(0x260) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function c22600019.retg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22600019.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local x=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local xc=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local g=Duel.SelectTarget(tp,c22600019.filter,tp,LOCATION_GRAVE,0,1,xc,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,x,g:GetCount(),0,0)
end

function c22600019.reop2(e,tp,eg,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
	   local g=Duel.GetDecktopGroup(1-tp,ct)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
