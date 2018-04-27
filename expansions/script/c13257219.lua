--宇宙战争兵器 护罩 破片罩
function c13257219.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257219.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257219.econ)
	e12:SetValue(c13257219.efilter)
	c:RegisterEffect(e12)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_REMOVE_COUNTER+0x353)
	e4:SetCondition(c13257219.ctcon1)
	e4:SetOperation(c13257219.ctop1)
	c:RegisterEffect(e4)
	c:RegisterFlagEffect(13257201,0,0,0,1)
	
end
function c13257219.eqlimit(e,c)
	local cl=c:GetFlagEffectLabel(13257200)
	if cl==nil then
		cl=0
	end
	local er=e:GetHandler():GetFlagEffectLabel(13257201)
	if er==nil then
		er=0
	end
	return not (er>cl) and (c:GetOriginalLevel()>=e:GetHandler():GetRank()) and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x9354)
end
function c13257219.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257219.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257219.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec==eg and ep==tp and bit.band(r,REASON_REPLACE)==REASON_REPLACE 
end
function c13257219.ctop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13257219,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
