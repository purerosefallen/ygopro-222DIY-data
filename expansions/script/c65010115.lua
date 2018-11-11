--瓶之骑士 迷迭香
function c65010115.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(65010115)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5da0),1,1)
	--extra link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetValue(c65010115.matval)
	c:RegisterEffect(e0)	
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c65010115.cttg)
	e1:SetOperation(c65010115.ctop)
	c:RegisterEffect(e1)
end
function c65010115.matval(e,c,mg)
	return c:IsCode(65010115)
end
function c65010115.filter(c)
	return c:IsSetCard(0x5da0) and c:IsFaceup()
end
function c65010115.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65010115.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65010115.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectTarget(tp,c65010115.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc:IsControler(1-tc:GetOwner()) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	end
end
function c65010115.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tc:GetOwner()) then
		tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tc:GetOwner())
		e1:SetReset(RESET_EVENT+0xec0000)
		tc:RegisterEffect(e1)
	end
end
