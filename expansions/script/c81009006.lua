--Answer·西瓜·FW
function c81009006.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c81009006.lcheck)
	c:EnableReviveLimit()
	--special summon (extra)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(81009006,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,81009006)
	e0:SetCondition(c81009006.espcon)
	e0:SetCost(c81009006.espcost)
	e0:SetTarget(c81009006.esptg)
	e0:SetOperation(c81009006.espop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81009006.regcon)
	e1:SetOperation(c81009006.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c81009006.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81009006,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81009906)
	e3:SetCondition(c81009006.thcon)
	e3:SetTarget(c81009006.thtg)
	e3:SetOperation(c81009006.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c81009006.vblcheck)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(c81009006.rsgcon)
	e5:SetOperation(c81009006.rsgop)
	c:RegisterEffect(e5)
	e4:SetLabelObject(e5)
end
function c81009006.lcheck(g,lc)
	return g:GetClassCount(Card.GetOriginalCode)==g:GetCount()
end
function c81009006.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c81009006.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(81009006,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81009006,4))
end
function c81009006.sfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c81009006.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c81009006.sfilter,1,nil,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c81009006.espcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(81009006)>0
end
function c81009006.cfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81009006.espcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81009006.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81009006.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81009006.espfilter(c,e,tp)
	return c:IsCode(81000065) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c81009006.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c81009006.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81009006.espop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81009006.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c81009006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(81009906)>0
end
function c81009006.thfilter(c)
	return (c:IsSetCard(0x46) or c:IsType(TYPE_RITUAL)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c81009006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81009006.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c81009006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81009006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81009006.mfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81009006.vblcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c81009006.mfilter,1,nil,nil) then
		e:GetLabelObject():SetLabel(2)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c81009006.rsgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==2
end
function c81009006.rsgop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(81009906,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81009006,5))
end
