--最后的晶石 泽洛
Duel.LoadScript("c22280001.lua")
c22280161.named_with_Spar=true
c22280161.named_with_Zero=true
function c22280161.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22280161.matfilter,1,1)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22280161,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22280161.descost)
	e1:SetTarget(c22280161.destg)
	e1:SetOperation(c22280161.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22280161,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22280161.sptg)
	e2:SetOperation(c22280161.spop)
	c:RegisterEffect(e2)
end
function c22280161.matfilter(c)
	return scorp.check_set_Spar(c) and c:IsType(TYPE_MONSTER)
end
function c22280161.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetLinkedGroup():Filter(Card.IsReleasable,nil)
	if chk==0 then return cg:GetCount()>0 end
	Duel.Release(cg,REASON_EFFECT)
end
function c22280161.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return cg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,cg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,cg,cg:GetCount(),0,0)
end
function c22280161.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local cg=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if cg:GetCount()<1 then return end
	Duel.Destroy(cg,REASON_EFFECT,LOCATION_REMOVED)
end
function c22280161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_DECK)
end
function c22280161.spfilter(c,e,tp,zone)
	return scorp.check_set_Spar(c) and c:IsType(TYPE_MONSTER) and c:IsSummonableCard()
end
function c22280161.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if not (c:IsRelateToEffect(e) and zone~=0) then return end
	local g=Duel.GetMatchingGroup(c22280161.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local rscard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			rscard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if rscard:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then
		Duel.SpecialSummon(rscard,0,tp,tp,false,false,POS_FACEUP,zone)
	else 
		Duel.ShuffleDeck(tp)
	end
end