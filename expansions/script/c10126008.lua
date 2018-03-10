--神匠神 破刃
function c10126008.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1335),1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c10126008.atkval)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1335))
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126008,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10126008)
	e3:SetTarget(c10126008.eqtg)
	e3:SetOperation(c10126008.eqop)
	c:RegisterEffect(e3)
end
function c10126008.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:GetPreviousEquipTarget() and Duel.GetLocationCount(c:GetOwner(),LOCATION_SZONE)>0
end
function c10126008.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126008.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c10126008.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10126008.eqfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil):GetFirst()
	if tc then
		if not Duel.Equip(tc:GetOwner(),tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10126008.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c10126008.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126008.atkval(e,c)
	local g=c:GetEquipGroup():Filter(c10126008.atkfilter,nil)
	local atk=g:GetSum(Card.GetTextAttack)
	return atk/2
end
function c10126008.atkfilter(c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:GetTextAttack()>0
end