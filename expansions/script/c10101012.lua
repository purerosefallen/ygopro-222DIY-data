--苍翼的交信
function c10101012.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10101012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10101012.sptg)
	e1:SetOperation(c10101012.spop)
	c:RegisterEffect(e1)	
end
c10101012.card_code_list={10101001}
function c10101012.spfilter1(c,e,tp)
	return c:IsSetCard(0x6330) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c10101012.filter1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1))
end
function c10101012.filter1(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(code)
end
function c10101012.spfilter2(c,e,tp)
	return c:IsSetCard(0x6330) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c10101012.filter2,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c10101012.filter2(c,code)
	return c:IsAbleToRemove() and c:IsCode(code)
end
function c10101012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c10101012.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c10101012.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10101012,0),aux.Stringid(10101012,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10101012,0))
	else
		Duel.SelectOption(tp,aux.Stringid(10101012,1))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND+LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c10101012.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,LOCATION_REMOVED)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	end
end
function c10101012.spop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,c10101012.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   local sg=Duel.SelectMatchingCard(tp,c10101012.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		   if sg:GetCount()>0 then
			   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		   end   
		end
	else
		local rc=Duel.GetFirstTarget()
		if rc and Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		   local rg=Duel.SelectMatchingCard(tp,c10101012.filter2,tp,LOCATION_GRAVE,0,1,1,nil,rc:GetCode())
		   if rg:GetCount()>0 then
			   Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		   end 
		end
	end
end