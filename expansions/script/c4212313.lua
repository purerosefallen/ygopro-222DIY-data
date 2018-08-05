--菲莉丝的工作室-菲莉丝
function c4212313.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212313,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c4212313.tfcost)
	e1:SetTarget(c4212313.tftg)
	e1:SetOperation(c4212313.tfop)
	c:RegisterEffect(e1)
	--destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4212313,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4212313)
	e2:SetCondition(c4212313.spcon)
	e2:SetTarget(c4212313.sptg)
	e2:SetOperation(c4212313.spop)
	c:RegisterEffect(e2)
	--destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4212313,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c4212313.descon)
	e3:SetTarget(c4212313.destg)
	e3:SetOperation(c4212313.desop)
	c:RegisterEffect(e3)	
end
function c4212313.cdfilter(c)
	return c:IsSetCard(0x2a5) and c:IsDiscardable()
end
function c4212313.tffilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2a5) and c:IsAbleToHand()
end
function c4212313.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212303.cdfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c4212303.cdfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c4212313.spcfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2a5)
end
function c4212313.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212313.tffilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c4212313.tfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c4212313.tffilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
function c4212313.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c4212313.spcfilter,nil)>0
end
function c4212313.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c4212313.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c4212313.descon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(e:GetHandler():GetReason(),0x41)==0x41 
end
function c4212313.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,2):FilterCount(function(c,e) return c:IsDestructable(e) end,nil,e)==2  end
end
function c4212313.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	if Duel.Destroy(g,REASON_EFFECT) then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,4212317) then
			if Duel.SelectYesNo(tp,502) then
				local sg = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_SZONE,0,1,1,nil,4212317)
				if Duel.Destroy(sg,REASON_EFFECT) then
					Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
				end
			else
				Duel.ConfirmCards(1-tp,e:GetHandler())
				Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
			end
		else
			Duel.ConfirmCards(1-tp,e:GetHandler())
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		end		
	end	
end