--绀珠传 无名的存在
function c9980031.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xa200),2,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980031.atkval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c9980031.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980031,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9980031)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9980031.setcon)
	e1:SetTarget(c9980031.settg)
	e1:SetOperation(c9980031.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c9980031.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa200) and c:GetBaseAttack()>=0
end
function c9980031.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c9980031.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c9980031.indcon(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end
function c9980031.setcfilter(c,tp,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0xa200) and c:IsFaceup() and c:IsControler(tp) and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0xa200) and c:IsPreviousPosition(POS_FACEUP)
			and c:GetPreviousControler()==tp and bit.extract(ec:GetLinkedZone(tp),c:GetPreviousSequence())~=0
	end
end
function c9980031.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980031.setcfilter,1,nil,tp,e:GetHandler())
end
function c9980031.setfilter(c)
	return c:IsSetCard(0x46) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xa200)) and c:IsSSetable()
end
function c9980031.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9980031.setfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9980031.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9980031.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end