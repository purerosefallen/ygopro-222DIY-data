--人形·囚魂丧心
function c1110012.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1110012.con1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110012,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1110012.con2)
	e2:SetTarget(c1110012.tg2)
	e2:SetOperation(c1110012.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110012.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SPIRIT)
end
function c1110012.con1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c1110012.cfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--
function c1110012.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(1110012)<1
end
--
function c1110012.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
--
function c1110012.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		local sc=sg:GetFirst()
		Duel.ConfirmCards(tp,sc)
		if not c:IsFaceup() then return end
		if not c:IsRelateToEffect(e) then return end
		if not sc:IsType(TYPE_MONSTER) then return end
		if not sc:IsType(TYPE_EFFECT) then return end
		local code=sc:GetCode()
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2_1:SetRange(LOCATION_MZONE)
		e2_1:SetLabel(code)
		e2_1:SetTargetRange(0,1)
		e2_1:SetValue(c1110012.val2_1)
		c:RegisterEffect(e2_1)
		local f=Card.RegisterEffect
		Card.RegisterEffect=function(tc,e,forced)
			e:SetCondition(c1110012.rcon2_2(e:GetCondition()))
			e:SetCost(c1110012.rcost2_2(e:GetCost()))
			f(tc,e,forced)
		end
		c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		Card.RegisterEffect=f
		c:RegisterFlagEffect(1110012,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,1,aux.Stringid(1110012,1))
		Duel.ShuffleHand(1-tp)
	end
end
--
function c1110012.val2_1(e,te)
	local code=e:GetLabel()
	return te:GetHandler():IsCode(code)
end
--
function c1110012.rcon2_2(con)
	return 
	function(e,tp,eg,ep,ev,re,r,rp)
		return not con or con(e,tp,eg,ep,ev,re,r,rp) or e:IsHasType(0x7e0)
	end
end
--
function c1110012.rcost2_2(cost)
	return 
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not cost or cost(e,tp,eg,ep,ev,re,r,rp,0) or e:IsHasType(0x7e0) end
		return not cost or e:IsHasType(0x7e0) or cost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
--
