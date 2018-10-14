--聚镒素 水火
function c10110012.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10110012.ffilter1,c10110012.ffilter2,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(c10110012.atkop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110012,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10110012.destg)
	e2:SetOperation(c10110012.desop)
	c:RegisterEffect(e2)
end
function c10110012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return c:GetAttack()>=300 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_MZONE)
end
function c10110012.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetAttack()>=1000 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-300)
		c:RegisterEffect(e1)
		if tc and tc:IsRelateToEffect(e) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c10110012.tgfilter,tp,LOCATION_DECK,0,1,nil,tc:GetAttribute()) and Duel.SelectYesNo(tp,aux.Stringid(10110012,1)) then
		   Duel.BreakEffect()
		   local g=Duel.SelectMatchingCard(tp,c10110012.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
		   Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c10110012.tgfilter(c,att)
	return c:IsSetCard(0x9332) and c:IsAbleToGrave() and c:IsAttribute(att)
end
function c10110012.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(100)
	c:RegisterEffect(e1)
end
function c10110012.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110012.ffilter3,1,nil,ATTRIBUTE_FIRE))
end
function c10110012.ffilter2(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110012.ffilter3,1,nil,ATTRIBUTE_WATER))
end
function c10110012.ffilter3(c,att)
	return c:IsFusionAttribute(att) and c:IsFusionSetCard(0x9332)
end