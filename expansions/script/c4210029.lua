--猫耳天堂-猫娘助手
function c4210029.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4210029)
	e1:SetTarget(c4210029.target)
	e1:SetOperation(c4210029.activate)
	c:RegisterEffect(e1)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210029,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)	
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c4210029.otcon)
	e3:SetTarget(c4210029.ottg)
	e3:SetOperation(c4210029.otop)
	c:RegisterEffect(e3)
end
function c4210029.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2af)
end
function c4210029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210029.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function c4210029.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
	local g=Duel.SelectMatchingCard(tp,c4210029.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)		
		if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:FilterCount(function(c)return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) end,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			if Duel.SelectEffectYesNo(tp,e:GetHandler(),500) 
				and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) then
				local rel = Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
				if Duel.Release(rel,REASON_EFFECT)~=0 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
function c4210029.spcfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x2af)
end
function c4210029.otcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4210029.spcfilter,1,nil,tp,rp)
end
function c4210029.ottg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c4210029.otop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end