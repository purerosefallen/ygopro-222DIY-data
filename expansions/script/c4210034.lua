--猫耳天堂-偶像椰子
function c4210034.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	e1:SetCondition(c4210034.spcon)
	e1:SetTarget(c4210034.sptg)
	e1:SetOperation(c4210034.spop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210034,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c4210034.condition)
	e2:SetTarget(c4210034.target)
	e2:SetOperation(c4210034.operation)
	c:RegisterEffect(e2)
	--return to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210034,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,4210034)
	e3:SetTarget(c4210034.rttg)
	e3:SetOperation(c4210034.rtop)
	c:RegisterEffect(e3)
	local e4 = e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_DECK) end)
	e4:SetTarget(c4210034.rttg,1)
	c:RegisterEffect(e4)
end
function c4210034.filter(c,e,tp,m1,m2,ft)
	local mg=m1:Filter(Card.IsReleasable,c)
	if m2 then mg:Merge(m2) end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetLevel,6,1,99,c)
	else
		return ft>-1 and mg:IsExists(c4210034.mfilterf,1,nil,tp,mg,c)
	end
end
function c4210034.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetLevel,6,0,99,rc)
	else return false end
end
function c4210034.relfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c4210034.repfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToDeck() 
end
function c4210034.repfilterex(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2af) and c:IsAbleToGrave()
end
function c4210034.spcon(e,c)	
	if c==nil then return true end
		local mg1=Duel.GetMatchingGroup(c4210034.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
		local mg2=Duel.GetMatchingGroup(c4210034.repfilter,tp,LOCATION_REMOVED,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)		
		return Duel.IsExistingMatchingCard(c4210034.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210028)
			and (e:GetHandler():IsLocation(LOCATION_HAND) or (e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024)))
end
function c4210034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==1 then return true end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetHandler():GetLocation())
end
function c4210034.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_COST+REASON_DISCARD,nil,4210028)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local showcard = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,4210024)
		Duel.ConfirmCards(1-tp,showcard)
		Duel.RaiseEvent(showcard,0x1420042a,e,REASON_COST,tp,0,0)
		Duel.ShuffleHand(tp)
	end
	local mg1=Duel.GetMatchingGroup(c4210034.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	local mg2=Duel.GetMatchingGroup(c4210034.repfilter,tp,LOCATION_REMOVED,0,nil)
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
			mat=mg:FilterSelect(tp,c4210034.mfilterf,1,1,nil,tp,mg,tc)
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
function c4210034.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c4210034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210034.cdcfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.SelectTarget(tp,c4210034.cdcfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,3,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c4210034.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT+REASON_RETURN)
	end
end
function c4210034.cdfilter(c) 
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(6) and c:IsAbleToHand()
end
function c4210034.cdcfilter(c) 
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c4210034.cdexfilter(c,e) 
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c4210034.rttg(e,tp,eg,ep,ev,re,r,rp,chk,num)
	if chk==0 then 
		local mg1=Duel.GetMatchingGroup(c4210034.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
		local mg2= (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024)
			and {Duel.GetMatchingGroup(c4210034.repfilterex,tp,LOCATION_DECK,0,nil)} or {nil})[1]
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c4210034.cdexfilter,tp,LOCATION_DECK,0,1,nil,e) 
			and Duel.IsExistingMatchingCard(c4210034.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
			and (num~=1 or e:GetHandler():IsPreviousLocation(LOCATION_DECK))
	end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4210034.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c4210034.cdexfilter,tp,LOCATION_DECK,0,1,1,nil,e):GetFirst()
	local mg1=Duel.GetMatchingGroup(c4210034.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,tc)
	local mg2=nil
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024) then 
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4210031,0))
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local showcard = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,4210024)
			Duel.ConfirmCards(1-tp,showcard)
			Duel.RaiseEvent(showcard,0x1420042a,e,REASON_COST,tp,0,0)
			Duel.ShuffleHand(tp)
			mg2 = Duel.GetMatchingGroup(c4210034.repfilterex,tp,LOCATION_DECK,0,nil)
		end	
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc then
		local mg=mg1:Filter(Card.IsReleasable,tc,tc)
		if mg2 then mg:Merge(mg2) end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc)
		end
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetLevel,6,1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c4210034.mfilterf,1,1,tc,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetLevel,6,0,99,tc)
			mat:Merge(mat2)
		end				
		local rm= mat:Filter(Card.IsLocation,tp,LOCATION_DECK)
		if Duel.SendtoGrave(rm,nil,0,REASON_COST+REASON_REPLACE)~=0 or Duel.Release(mat,REASON_COST+REASON_RELEASE)~=0 then 
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			local code = tc:GetCode()
			tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
			tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		end
	end
end