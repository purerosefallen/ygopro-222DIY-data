--猫耳天堂-偶像香草
function c4210036.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	e1:SetCondition(c4210036.spcon)
	e1:SetTarget(c4210036.sptg)
	e1:SetOperation(c4210036.spop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210036,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c4210036.condition)
	e2:SetTarget(c4210036.target)
	e2:SetOperation(c4210036.operation)
	c:RegisterEffect(e2)
	--return to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210036,3))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,4210036)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c4210036.rtcost)
	e3:SetTarget(c4210036.rttg)
	e3:SetOperation(c4210036.rtop)
	c:RegisterEffect(e3)
end
function c4210036.filter(c,e,tp,m1,m2,ft)
	local mg=m1:Filter(Card.IsReleasable,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetLevel,6,1,99,c)
	else
		return ft>-1 and mg:IsExists(c4210036.mfilterf,1,nil,tp,mg,c)
	end
end
function c4210036.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetLevel,9,0,99,rc)
	else return false end
end
function c4210036.relfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c4210036.repfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToDeck() 
end
function c4210036.spcon(e,c)	
	if c==nil then return true end
		local mg1=Duel.GetMatchingGroup(c4210036.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
		local mg2=Duel.GetMatchingGroup(c4210036.repfilter,tp,LOCATION_REMOVED,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)		
		return Duel.IsExistingMatchingCard(c4210036.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210028)
			and (e:GetHandler():IsLocation(LOCATION_HAND) or (e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024)))
end
function c4210036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==1 then return true end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetHandler():GetLocation())
end
function c4210036.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_COST+REASON_DISCARD,nil,4210028)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local showcard = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND,0,nil,4210024):Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,showcard)
		Duel.ShuffleHand(tp)
	end
	local mg1=Duel.GetMatchingGroup(c4210036.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	local mg2=Duel.GetMatchingGroup(c4210036.repfilter,tp,LOCATION_REMOVED,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=e:GetHandler()
	if tc then
		local mg=mg1:Filter(Card.IsReleasable,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetLevel,6,1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c4210036.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetLevel,6,0,99,tc)
			mat:Merge(mat2)
		end				
		local rm= mat:Filter(Card.IsLocation,tp,LOCATION_REMOVED)
		Duel.SendtoDeck(rm,nil,0,REASON_COST)
		Duel.Release(mat,REASON_COST+REASON_RELEASE)
		local code = tc:GetCode()
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		tc:RegisterFlagEffect(code,RESET_EVENT+0xcff0000,0,0)
	end
end

function c4210036.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c4210036.tgfilter(c,e,tp)
	return c:IsSetCard(0x2af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210036.cdfilter(c) 
	return c:IsSetCard(0x2af) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c4210036.cdcfilter(c) 
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c4210036.cdrmfilter(c) 
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c4210036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4210036.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c4210036.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c4210036.cdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and
		Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024) then
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		if Duel.IsExistingMatchingCard(c4210036.cdrmfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) then
			if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4210036,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				local showcard = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND,0,nil,4210024):Select(tp,1,1,nil)
				Duel.ConfirmCards(1-tp,showcard)
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local cd = Duel.SelectMatchingCard(tp,c4210036.cdrmfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
				Duel.SendtoHand(cd,nil,REASON_EFFECT)
			end
		end
	end
end
function c4210036.rtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024)
		or e:GetHandler():IsDiscardable() end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4210036,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local showcard = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND,0,nil,4210024):Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tp,showcard)
			Duel.ShuffleHand(tp)
			else
			Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
		end
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)	
	end
end
function c4210036.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210036.cdfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c4210036.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c4210036.cdfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end