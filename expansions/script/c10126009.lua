--神匠神 断钢
function c10126009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),2,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c10126009.atkval)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126009,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c10126009.target)
	e2:SetOperation(c10126009.operation)
	c:RegisterEffect(e2)
end
function c10126009.atkval(e,c)
	local g=c:GetLinkedGroup():Filter(c10126009.afilter,nil)
	local atk=g:GetSum(Card.GetAttack)
	return atk/2
end
function c10126009.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1335)
end
function c10126009.filter(c,tp)
	return c10126009.afilter(c) and (Duel.IsExistingMatchingCard(c10126009.efilter1,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil,tp,c) or Duel.IsExistingMatchingCard(c10126009.efilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp,c))
end
function c10126009.efilter1(c,tp,rc)
	return c:IsSetCard(0x1335) and bit.band(c:GetType(),0x40002)==0x40002 and c:CheckEquipTarget(rc) and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:GetEquipTarget()~=rc and bit.band(c:GetOriginalType(),TYPE_MONSTER)==0
end
function c10126009.efilter2(c,tp,rc)
	local ec=c:GetEquipTarget()
	return ec and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and ec~=rc and (c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and ec:IsControler(tp)
end
function c10126009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10126009.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10126009.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10126009.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local b1=Duel.IsExistingMatchingCard(c10126009.efilter1,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil,tp,g:GetFirst())
	local b2=Duel.IsExistingMatchingCard(c10126009.efilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp,g:GetFirst())
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,550)
	if b1 and b2 then
	   op=Duel.SelectOption(tp,aux.Stringid(10126009,2),aux.Stringid(10126009,3))
	elseif b1 then
	   op=Duel.SelectOption(tp,aux.Stringid(10126009,2))
	else
	   op=Duel.SelectOption(tp,aux.Stringid(10126009,3))+1
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10126009.operation(e,tp,eg,ep,ev,re,r,rp)
	local op,c,tc=e:GetLabel(),Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	if op==0 then
	   tc=Duel.SelectMatchingCard(tp,c10126009.efilter1,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil,tp,c):GetFirst()
	else
	   tc=Duel.SelectMatchingCard(tp,c10126009.efilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,tp,c):GetFirst()
	end
	if tc and Duel.Equip(tp,tc,c,true) and op==1 then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	   e1:SetCode(EFFECT_EQUIP_LIMIT)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(c10126009.eqlimit)
	   tc:RegisterEffect(e1)
	end
end
function c10126009.eqlimit(e,c)
	return e:GetOwner()==c
end