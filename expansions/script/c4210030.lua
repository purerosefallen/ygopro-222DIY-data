--猫耳天堂-猫娘切换
function c4210030.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4210030)
	e1:SetCost(c4210030.cost)
	e1:SetTarget(c4210030.target)
	e1:SetOperation(c4210030.activate)
	c:RegisterEffect(e1)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210030,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)	
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c4210030.otcon)
	e3:SetTarget(c4210030.ottg)
	e3:SetOperation(c4210030.otop)
	c:RegisterEffect(e3)
	c4210030.tg = 0
end
function c4210030.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2af)
end
function c4210030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c4210030.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c4210030.cfilter,1,1,nil,ft,tp)
	if g:FilterCount(function(c)return c:GetFlagEffect(4210010)~=0 end,nil,tp)>0 then c4210030.tg = 1 else c4210030.tg = 0 end
	Duel.Release(g,REASON_COST)
end
function c4210030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210030.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if c4210030.tg == 1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	end
end
function c4210030.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4210010.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c4210030.tg ~= 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g:GetFirst():RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
			g:GetFirst():RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
			local gc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
			if gc:GetCount()>0 then
				Duel.SendtoHand(gc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,gc)
				c4210030.tg = 0
			end
		end
	end
end
function c4210030.spcfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x2af)
end
function c4210030.otcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4210030.spcfilter,1,nil,tp,rp)
end
function c4210030.ottg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c4210030.otop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end