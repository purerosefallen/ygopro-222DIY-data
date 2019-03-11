--蓝色拿破仑·上条春菜
function c81008007.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81008007)
	e1:SetTarget(c81008007.tg)
	e1:SetOperation(c81008007.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--synchro limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c81008007.synlimit)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetTarget(c81008007.synlimit2)
	c:RegisterEffect(e6)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(LOCATION_DECKBOT)
	e4:SetCondition(c81008007.rdcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c81008007.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetValue(c81008007.stlimit)
	c:RegisterEffect(e7)
end
function c81008007.filter(c)
	return c:IsCode(81010004) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c81008007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81008007.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c81008007.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c81008007.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c81008007.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c81008007.synlimit2(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c81008007.rdcon(e)
	return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_SYNCHRO) and e:GetLabel()==1
end
function c81008007.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and not c:IsRace(RACE_MACHINE)
end
function c81008007.valcheck(e,c)
	if c:GetMaterial():IsExists(c81008007.sfilter,1,e:GetHandler()) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c81008007.stlimit(e,c)
	if not c then return false end
	return not c:IsLinkAbove(4)
end
