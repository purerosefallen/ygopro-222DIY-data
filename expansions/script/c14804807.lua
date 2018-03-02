--IDOL 呆萌
function c14804807.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804807),LOCATION_MZONE)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4848),2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c14804807.atktg)
	e1:SetValue(c14804807.atkval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c14804807.condition)
	e2:SetTarget(c14804807.imtg)
	e2:SetValue(c14804807.efilter)
	c:RegisterEffect(e2)
	 --todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14804807,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c14804807.target)
	e4:SetOperation(c14804807.operation)
	c:RegisterEffect(e4)
end

function c14804807.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804807.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804807.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804807.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-300
end

function c14804807.cfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804807.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804807.cfilter,tp,LOCATION_MZONE,0,4,nil)
end
function c14804807.imtg(e,c)
	return c:IsSetCard(0x4848)
end
function c14804807.efilter(e,te)
	return  not te:GetOwner():IsSetCard(0x4848) and te:IsActiveType(TYPE_TRAP) 
end

function c14804807.spfilter(c,e,tp)
	return c:IsSetCard(0x4848) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14804807.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c14804807.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(1-tp,1)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingTarget(c14804807.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c14804807.spfilter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c14804807.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
