--忆梦长廊 琪亚娜
function c75646054.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c75646054.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c75646054.eqcon)
	e1:SetOperation(c75646054.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646054,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c75646054.discon)
	e3:SetTarget(c75646054.distg)
	e3:SetOperation(c75646054.disop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(c75646054.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c75646054.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2c0)
end
function c75646054.cfilter(c,sc)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x2c0) and c:IsFaceup() and sc:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x2c0) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(sc:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c75646054.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646054.cfilter,1,nil,e:GetHandler()) 
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c75646054.filter(c,ec)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c75646054.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75646054)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c75646054.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
		tc:AddCounter(0x1b,2)
	end
end
function c75646054.eftg(e,c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x2c0)
		and c:GetEquipTarget()==e:GetHandler()
end
function c75646054.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetColumnGroup():IsContains(re:GetHandler())
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c75646054.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c75646054.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end