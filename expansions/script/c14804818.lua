--IDOL 那那西
function c14804818.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804818),LOCATION_MZONE)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4848),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c14804818.atktg)
	e1:SetValue(c14804818.atkval)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c14804818.limcon)
	e2:SetOperation(c14804818.chainop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14804818,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c14804818.target)
	e3:SetOperation(c14804818.activate)
	c:RegisterEffect(e3)
end
function c14804818.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804818.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804818.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804818.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-300
end
function c14804818.cfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804818.limcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804818.cfilter,tp,LOCATION_ONFIELD,0,8,nil)
end
function c14804818.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end
function c14804818.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function c14804818.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return  false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	if chk==0 then return Duel.GetMZoneCount(1-tp)>0
		and Duel.IsExistingMatchingCard(c14804818.spfilter,1-tp,LOCATION_DECK,0,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
function c14804818.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
			end
		Duel.ShuffleDeck(p)
	end
			if Duel.GetMZoneCount(1-tp)<=0 then return end
				   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
					local g=Duel.SelectMatchingCard(1-tp,c14804818.spfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,1-tp)
					local tc=g:GetFirst()
					if tc and Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_ATTACK) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(1)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_UNRELEASABLE_EFFECT)
					e3:SetValue(1)
					e3:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e3,true)
					local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_SINGLE)
					e4:SetCode(EFFECT_UNRELEASABLE_SUM)
					e4:SetValue(1)
					e4:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e4,true)
					local e5=e4:Clone()
					e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
					tc:RegisterEffect(e5,true)
					Duel.SpecialSummonComplete()
				end
end
