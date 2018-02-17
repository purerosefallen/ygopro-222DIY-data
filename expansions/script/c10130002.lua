--幻层驱动 膜层
function c10130002.initial_effect(c)
	--set1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(10130002,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10130002)
	e1:SetTarget(c10130002.settg)
	e1:SetOperation(c10130002.setop)
	c:RegisterEffect(e1)
	--set2
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCost(c10130002.setcon)
	c:RegisterEffect(e2)
	c10130002.flip_effect=e1
end
function c10130002.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c10130002.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=tp
	if e:GetCode()==EVENT_TO_GRAVE then p=1-tp end
	if chk==0 then return Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c10130002.setfilter(c,e,tp)
	return ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
end
function c10130002.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=tp
	if e:GetCode()==EVENT_TO_GRAVE then p=1-tp end
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		if g:IsExists(c10130002.setfilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(10130002,2)) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		   local tc=g:FilterSelect(tp,c10130002.setfilter,1,1,nil,e,tp):GetFirst()
		   local ct=0
		   if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			  ct=Duel.SSet(tp,Group.FromCards(tc))
		   else
			  ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		   end
		   g:RemoveCard(tc)
		   local sg=Duel.GetMatchingGroup(c10130002.ssfilter,tp,LOCATION_MZONE,0,nil)
		   Duel.ConfirmCards(1-tp,tc)
		   if ct>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10130002,3)) then
			  Duel.BreakEffect()
			  Duel.ShuffleSetCard(sg)
		   end
		end
		if e:GetValue()==1 then
		   Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c10130002.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end