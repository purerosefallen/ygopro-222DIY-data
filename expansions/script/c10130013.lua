--量子驱动 Δ构筑
function c10130013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa336),2,2)
	c:EnableReviveLimit()
	--set or special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130013,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10130013)
	e1:SetCondition(c10130013.scon)
	e1:SetTarget(c10130013.stg)
	e1:SetOperation(c10130013.efop)
	c:RegisterEffect(e1)
	--Release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130013,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10130113)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c10130013.rcost)
	e2:SetTarget(c10130013.rtg)
	e2:SetOperation(c10130013.efop)
	c:RegisterEffect(e2)
end
function c10130013.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10130013.rfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	if not c.flip_effect or not c:IsOriginalSetCard(0xa336) then return false end
	local target=c.flip_effect:GetTarget()
	return not target or target(e,tp,eg,ep,ev,re,r,rp,0)
end
function c10130013.rfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return c10130013.rfilter2(c,e,tp,eg,ep,ev,re,r,rp) and c:IsReleasable()
end
function c10130013.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10130013.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectMatchingCard(tp,c10130013.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.Release(tc,REASON_COST)
	local te=tc.flip_effect
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c10130013.efop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10130013.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10130013.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10130013.rfilter2(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c10130013.rfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_MESSAGE,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,c10130013.rfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local te=tc.flip_effect
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c10130013.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end