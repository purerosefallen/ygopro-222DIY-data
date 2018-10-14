--猫耳天堂-猫耳召唤
function c4210026.initial_effect(c)
	--Activate
	c4210026.count = 0
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4210026)
	e1:SetCost(c4210026.cost)
	e1:SetTarget(c4210026.target)
	e1:SetOperation(c4210026.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetDescription(aux.Stringid(4210026,3))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c4210026.thcost)
    e2:SetTarget(c4210026.thtg)
    e2:SetOperation(c4210026.thop)
    c:RegisterEffect(e2)
end
function c4210026.tgfilter(c,e,tp)
	return c:IsSetCard(0xa2f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0xa2f) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0xa2f)
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(4210010)~=0 then c4210026.count = c4210026.count +1 end
	end
	Duel.Release(g,REASON_COST)
end
function c4210026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK+LOCATION_HAND) and chkc:IsControler(tp) and c4210026.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4210026.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4210026.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4210026.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=-1
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
		local code = tc:GetCode()
		if code ~= 4210008 then
			tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
			tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		end
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		tc:RegisterFlagEffect(code,RESET_EVENT+0xcff0000,0,0)
		if c4210026.count > 0 then
			if c4210026.count > 1 then
				if Duel.IsExistingTarget(function(c) return c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) then
					op=Duel.SelectOption(tp,aux.Stringid(4210026,1),aux.Stringid(4210026,2))
				else op=0 end					
			else if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4210026,1)) then op=0 else op=-1 end				
			end
		end
		if op ==0 then 
			Duel.Draw(tp,1,REASON_EFFECT)
		end	
		if op ==1 then 
			local g=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
			if g:GetFirst():IsReleasableByEffect() then		
				Duel.Release(g,REASON_EFFECT)
			end
		end
	end
end
function c4210026.filter(c)
	return c:IsSetCard(0xa2f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c4210026.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210026.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210026.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c4210026.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end