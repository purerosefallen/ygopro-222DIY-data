--莉蒂与苏尔的工作室-莉蒂
function c4212314.initial_effect(c)
	--to hand
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_DRAW)
    e0:SetCondition(c4212314.regcon)
    e0:SetOperation(c4212314.regop)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c4212314.condition)
	e1:SetCost(c4212314.cost)
    e1:SetTarget(c4212314.target)
    e1:SetOperation(c4212314.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,4212314)
	e2:SetCost(c4212314.spcost)
    e2:SetTarget(c4212314.sptg)
    e2:SetOperation(c4212314.spop)
    c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4212314,0))
	e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c4212314.con)
    e3:SetTarget(c4212314.tg)
    e3:SetOperation(c4212314.op)
    c:RegisterEffect(e3)
end
function c4212314.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212314.regcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetFlagEffect(tp,4212314)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function c4212314.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SelectYesNo(tp,aux.Stringid(4212314,0)) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
        c:RegisterEffect(e1)
        c:RegisterFlagEffect(4212314,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
    end
end
function c4212314.twfilter(c)
	return c:IsCode(4212315) and c:IsAbleToHand()
end
function c4212314.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c4212314.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(4212314)~=0 end
end
function c4212314.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212314.twffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c4212314.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c4212314.twfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
function c4212314.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c4212314.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE))
		and Duel.IsExistingMatchingCard(function(c) return c:IsCode(4212315) or c:IsCode(4212318) end,tp,LOCATION_ONFIELD,0,1,nil)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c4212314.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE))) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c4212314.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c4212314.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_SZONE,LOCATION_SONE,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
end
function c4212314.op(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local tc = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
	if tc:GetCount()>0 then
		local seq = tc:GetFirst():GetSequence()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(c4212314.mfilter,tp,LOCATION_SZONE,0,nil)>=3  then
			local e4=Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_FIELD)
            e4:SetCode(EFFECT_DISABLE)
            e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
            e4:SetTarget(c4212314.distg)
            e4:SetReset(RESET_PHASE+PHASE_END)
            e4:SetLabel(seq)
            Duel.RegisterEffect(e4,tp)
            local e5=Effect.CreateEffect(c)
            e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e5:SetCode(EVENT_CHAIN_SOLVING)
            e5:SetOperation(c4212314.disop)
            e5:SetReset(RESET_PHASE+PHASE_END)
            e5:SetLabel(seq)
            Duel.RegisterEffect(e5,tp)
		end
	end
end
function c4212314.distg(e,c)
    local seq=e:GetLabel()
    local p=c:GetControler()
    local tp=e:GetHandlerPlayer()
    return c:IsType(TYPE_MONSTER)
        and ((p==tp and c:GetSequence()==seq
			or (math.ceil(c:GetSequence())==5 and seq==1 ) 
			or (math.ceil(c:GetSequence())==6 and seq==3 )		
		) or (p==1-tp and c:GetSequence()==4-seq
			or (math.ceil(c:GetSequence())==6 and seq==1 ) 
			or (math.ceil(c:GetSequence())==5 and seq==3 ) 
		))
end
function c4212314.disop(e,tp,eg,ep,ev,re,r,rp)
    local tseq=e:GetLabel()
    local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
    if bit.band(loc,LOCATION_MZONE)~=0 and re:IsActiveType(TYPE_MONSTER)
        and ((rp==tp and seq==tseq
			or (tseq==5 and seq==1 ) 
			or (tseq==6 and seq==3 )	
		) or (rp==1-tp and seq==4-tseq
			or (tseq==6 and seq==1 ) 
			or (tseq==5 and seq==3 ) 
		)) then
        Duel.NegateEffect(ev)
    end
end