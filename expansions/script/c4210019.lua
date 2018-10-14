--猫耳天堂-水无月家的猫娘
function c4210019.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,function(c)return c:IsLinkRace(RACE_BEASTWARRIOR) and c:GetFlagEffect(4210010)~=0 end,1)
	c:EnableReviveLimit()
	--release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210019,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c4210019.rescon)
	e1:SetCost(c4210019.rescost)
	e1:SetTarget(c4210019.restg)
	e1:SetOperation(c4210019.resop)
	c:RegisterEffect(e1)
	--nagate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210019,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c4210019.discon)
	e2:SetCost(c4210019.discost)
	e2:SetTarget(c4210019.distg)
	e2:SetOperation(c4210019.disop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210019,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,4210019) 
	e3:SetCost(c4210019.spcost)
	e3:SetTarget(c4210019.sptg)
	e3:SetOperation(c4210019.spop)
	c:RegisterEffect(e3)
	c4210019.lgc1 = 0
	c4210019.lgc2 = 0
end
function c4210019.rescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4210019.clfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c4210019.resfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function c4210019.rescost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c4210019.clfilter,1,e:GetHandler(),lg) end
	local lg=e:GetHandler():GetLinkedGroup():Filter(c4210019.resfilter,nil)
	c4210019.lgc1 = lg:FilterCount(function(c) return c:GetControler()==tp end,nil,tp)
	c4210019.lgc2 = lg:FilterCount(function(c) return c:GetControler()==1-tp end,nil,1-tp)
	Duel.Release(lg,REASON_COST)
end
function c4210019.restg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsPlayerCanDraw(tp,c4210019.lgc1) and Duel.IsPlayerCanDraw(1-tp,c4210019.lgc2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c4210019.lgc1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,c4210019.lgc2)
end
function c4210019.resop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,c4210019.lgc1,REASON_EFFECT)
	Duel.Draw(1-tp,c4210019.lgc2,REASON_EFFECT)
	c4210019.lgc1 =0 
	c4210019.lgc2 =0
end
function c4210019.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c4210019.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xa2f) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xa2f)	
	if g:GetFirst():GetFlagEffect(4210010) then
		e:GetHandler():RegisterFlagEffect(4210010,RESET_CHAIN,0,0)
	end
	Duel.Release(g,REASON_COST)
end
function c4210019.disfilter(c,e,tp)
	return c:IsSetCard(0xa2f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c4210019.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if e:GetHandler():GetFlagEffect(4210010)~=0 then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c4210019.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c4210019.rfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToRemoveAsCost()
		and ((c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)) 
			or(c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)))
end
function c4210019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210019.rfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210019.rfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c4210019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
	c:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210018,1))
	c:RegisterFlagEffect(4210018,RESET_EVENT+0xcff0000,0,0)
end